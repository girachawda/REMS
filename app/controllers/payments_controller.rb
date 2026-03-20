class PaymentsController < ApplicationController
  before_action :require_login

  def index
    @payments = current_user.account.payments
  end

  def new
    @payment = current_user.account.payments.build
  end

  def create
    @payment = current_user.account.payments.build(
      amount: params[:payment][:amount],
      method: params[:payment][:method],
      paid_at: Time.current
    )

    if @payment.save
      redirect_to account_path(current_user.account), notice: "Payment successful"
    else
      render :new, status: :unprocessable_entity
    end

  end
end
