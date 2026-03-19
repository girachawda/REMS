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
    @account = current_user.account
    # yo sam/alex use @monthly_invoices to pull all of the invoices in the previous month, which will allow you to pull info from them as needed, it's defined at the bottom of this method
    for lease in current_user.leases
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
      last_due_date = last_rent_invoice&.due_date || lease.start_date.end_of_month
      today = Date.current

      while today > last_due_date do
        water_charges = lease.unit.utility.water_charges
        electricity_charges = lease.unit.utility.electricity_charges
        waste_management_charges = lease.unit.utility.waste_management_charges

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

      last_autopayment = @account.payments.where(method: "automatic").order(created_at: :desc).first
      last_autopayment_date = last_autopayment&.created_at&.to_date || lease.start_date

      while today > last_autopayment_date do
        payment = @account.payments.create(
          amount: amount,
          method: "automatic"
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

    @monthly_invoices = @account.invoices.where(lease: lease, created_at: Date.current.last_month.beginning_of_month..Date.current.last_month.end_of_month).order(due_date: :desc)
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
