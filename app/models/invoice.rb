# Bills sent to tenants for rent, utilities, or maintenance costs
class Invoice < ApplicationRecord
  belongs_to :lease
  belongs_to :account

  # When we create an invoice, add the charge to their account balance
  after_create :apply_to_balance
  
  validates :charge_type, inclusion: { in: %w[utility rent maintenance] }

  # Add invoice total to the account balance (what they owe)
  def apply_to_balance
    account.update_column(:balance, account.balance + total_charge)
  end
end
