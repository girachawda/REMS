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
        @account.update_column(:balance, @account.balance + amount)
      end

      last_utility_invoice = @account.invoices.where(lease: lease, charge_type: "utility").order(due_date: :desc).first
      last_due_date = last_rent_invoice&.due_date || lease.start_date.end_of_month
      amount = rand(100)
      today = Date.current

      ## todo, gotta add utility fields to the lease table
      while today > last_due_date do
        invoice = @account.invoices.create(
          lease: lease,
          charge_type: "utility",
          total_charge: amount,
          due_date: last_due_date >> 1,
          status: "unpaid"
        )
        last_due_date = last_due_date >> 1
        @account.update_column(:balance, @account.balance + amount)
      end
    end
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
