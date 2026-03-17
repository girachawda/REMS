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
      account.account.set_discount(
        discount_percentage: params[:discount_percentage]
      )
    end
  end
end
