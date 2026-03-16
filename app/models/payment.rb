class Payment < ApplicationRecord
  belongs_to :account

  def apply_to_balance
    account.update_column(:balance, account.balance - amount)
  end
end
