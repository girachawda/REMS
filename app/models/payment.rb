class Payment < ApplicationRecord
  belongs_to :account
  after_create :apply_to_balance
  
  def apply_to_balance
    account.update_column(:balance, account.balance - amount)
  end
end
