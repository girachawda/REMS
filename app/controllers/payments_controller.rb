# Tenants make manual payments here
class PaymentsController < ApplicationController
  before_action :require_login

  def index
    @payments = current_user.account.payments
  end

  def new
    @payment = current_user.account.payments.build
  end

  # Process a manual payment (automatic payments happen in accounts#show)
  def create
    @payment = current_user.account.payments.build(payment_params)
    @payment.paid_at = Time.current

    if @payment.save
      redirect_to account_path(current_user.account), notice: "Payment successful"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def payment_params
    params.require(:payment).permit(:amount, :method)
  end
end
