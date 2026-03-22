class AccountsController < ApplicationController
  before_action :require_login

  def index
    if current_user.tenant?
        redirect_to account_path(current_user.account)
    else
      @accounts = Account.all
    end
  end

  def show
    @account =
      if current_user.tenant?
        current_user.account
      else
        Account.find(params[:id])
      end

    for lease in @account.user.leases.where(active: true)
      # autorenewal logic
      if Date.current > lease.end_date
        if lease.renewal_policy == "automatic"
          lease.update_column(:end_date, lease.end_date >> 12)
        else
          lease.update_column(:active, false)
        end
      end

      last_rent_invoice = @account.invoices.where(lease: lease, charge_type: "rent").order(due_date: :desc).first
      last_due_date = last_rent_invoice&.due_date || lease.start_date.end_of_month
      amount = @account.automatic_payment_amount(lease.unit.rental_rate)
      today = Date.current

      while today > last_due_date do
        invoice = @account.invoices.create(
          lease: lease,
          charge_type: "rent",
          total_charge: amount,
          due_date: last_due_date >> 1,
          status: "unpaid"
        )
        last_due_date = last_due_date >> 1
      end

      last_utility_invoice = @account.invoices.where(lease: lease, charge_type: "utility").order(due_date: :desc).first
      last_due_date = last_utility_invoice&.due_date || lease.start_date.end_of_month
      today = Date.current

      while today > last_due_date do
        utility = lease.utility
        if utility.nil?
          utility = lease.create_utility!(
            water_charges: rand(100),
            electricity_charges: rand(100),
            waste_management_charges: rand(100)
          )
        else
          ## This is just so there's utility data in the db, in real world, it would be updated by utility provider
          lease.utility.update_column(:water_charges, rand(100))
          lease.utility.update_column(:electricity_charges, rand(100))
          lease.utility.update_column(:waste_management_charges, rand(100))
        end

        water_charges = utility.water_charges
        electricity_charges = utility.electricity_charges
        waste_management_charges = utility.waste_management_charges

        invoice = @account.invoices.create(
          lease: lease,
          charge_type: "utility",
          total_charge: water_charges + electricity_charges + waste_management_charges,
          due_date: last_due_date >> 1,
          status: "unpaid",
          water_charges: water_charges,
          electricity_charges: electricity_charges,
          waste_management_charges: waste_management_charges
        )
        last_due_date = last_due_date >> 1
      end

      last_autopayment = @account.payments.where(method: "automatic", lease_id: lease.id).order(created_at: :desc).first
      last_autopayment_date = last_autopayment&.created_at&.to_date || lease.start_date

      while today > last_autopayment_date do
        payment = @account.payments.create(
          amount: amount,
          method: "automatic",
          lease: lease
        )
        payment.save!
        if @account.payment_cycle == "monthly"
          last_autopayment_date = last_autopayment_date >> 1
        elsif @account.payment_cycle == "quarterly"
          last_autopayment_date = last_autopayment_date >> 3
        elsif @account.payment_cycle == "bi-annually"
          last_autopayment_date = last_autopayment_date >> 6
        elsif @account.payment_cycle == "annually"
          last_autopayment_date = last_autopayment_date >> 12
        end
      end
    end

    total_balance = @account.balance
    if total_balance <= 0
      for invoice in @account.invoices do
        invoice.update_column(:status, "paid")
      end
    else
      for invoice in @account.invoices.where(status: "unpaid").order(due_date: :desc) do
        if total_balance > 0
          total_balance = total_balance - invoice.total_charge
        else
          invoice.update_column(:status, "paid")
        end
      end
    end

    for invoice in @account.invoices.where(status: "unpaid").order(due_date: :desc) do
      if invoice.due_date < Date.current
        invoice.update_column(:status, "overdue")
        flash.now[:alert] = "Outstanding invoices have passed the due date. Please pay as soon as possible."
      end
    end

    invoice_dates = @account.invoices.where.not(due_date: nil).order(due_date: :desc).pluck(:due_date)
    @available_months = invoice_dates.map { |date| date.strftime("%Y-%m") }.uniq
  
    if params[:month].present?
      @selected_month = Date.strptime(params[:month], "%Y-%m")
    elsif invoice_dates.any?
      @selected_month = invoice_dates.first.beginning_of_month
    else
      @selected_month = Date.current.beginning_of_month
    end
  
    @monthly_invoices = @account.invoices.where(
      due_date: @selected_month.beginning_of_month..@selected_month.end_of_month
    ).order(due_date: :desc)
  end

  # for payment cycle (show variable rate in front end), and bank transfer info
  def update
    if current_user.account.update(
      payment_cycle: params[:payment_cycle],
      bank_transfer_number: params[:bank_transfer_number]
      )
        redirect_to account_path(current_user.account), notice: "Preferences updated"
    end
  end

  # only for admins
  def set_discount
    if current_user.tenant?
      redirect_to account_path(current_user.account)
    else
      account = Account.find(params[:id])
      account.set_discount(
        discount_percentage: params[:discount_percentage]
      )
    end
  end
end
