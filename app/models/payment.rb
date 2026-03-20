class Payment < ApplicationRecord
  belongs_to :account
  after_create :apply_to_balance

  validates :amount,
    presence: { message: "Please enter a payment amount." },
    numericality: { greater_than: 0, message: "Payment amount must be greater than $0." }

  validates :method,
    presence: { message: "Please select a payment method." }
    
  def apply_to_balance
    account.update_column(:balance, account.balance.to_f - amount.to_f)
  end
end
