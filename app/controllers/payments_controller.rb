class PaymentsController < ApplicationController
  before_action :require_login

  def index
    @payments = current_user.account.payments
  end

  def new
    @payment = current_user.account.payments.build
  end

  def create
    payment = current_user.account.payments.build(
      amount: params[:amount],
      method: params[:method],
      paid_at: Time.current
    )
    payment.save!
    redirect_to account_path, notice: "Payment successful"
  end
end
