class InvoicesController < ApplicationController
  before_action :require_login

  # if tenant, list their invoices, if staff, list all invoices
  # list tenant invoices
  def index
    if current_user.tenant?
      @invoices = current_user.account.invoices
    else
      @invoices = Invoice.all
    end
  end

  # list specific invoice
  def show
    if current_user.tenant?
      @invoice = current_user.account.invoices.find(params[:id])
    else
      @invoice = Invoice.find(params[:id])
    end
  end

  # generate invoice
  def create
    invoice = current_user.account.invoices.build(
        total_charge: params[:total_charge],
        due_date: params[:due_date],
        lease_id: params[:lease_id],
        charge_type: params[:charge_type],
        status: "unpaid"
      )
    invoice.save!
    redirect_to invoice_path(invoice), notice: "New invoice for you bro"
  end

  def record_payment
    invoice = current_user.account.invoices.find(params[:id])
    
    if current_user.account.balance <= 0
      invoice.update(status: "paid")
      redirect_to account_path, notice: "Outstanding invoices are paid"
    else
      redirect_to account_path, alert: "Outstanding balance remains on account"
    end
  end

  def mark_overdue
    invoice = current_user.account.invoices.find(params[:id])

    if current_user.account.balance <= 0
      invoice.update(status: "paid")
      redirect_to account_path, notice: "Outstanding invoices are paid"
    else
      invoice.update(status: "overdue")
      redirect_to account_path, alert: "Your payments are overdue. Pay up."
    end
  end
end
