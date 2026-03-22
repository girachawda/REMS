# Tracks rent and other payments made by tenants
class Payment < ApplicationRecord
  belongs_to :account
  belongs_to :lease, optional: true

  # After creating a payment, automatically reduce the account balance and mark automatic payments as paid
  after_create :apply_to_balance
  after_create :sync_automatic

  validates :amount,
    presence: { message: "Please enter a payment amount." },
    numericality: { greater_than: 0, message: "Payment amount must be greater than $0." }

  validates :method,
    presence: { message: "Please select a payment method." }

  # Subtract payment from the account's outstanding balance
  def apply_to_balance
    account.update_column(:balance, account.balance.to_f - amount.to_f)
  end

  # If it's an automatic payment, mark it as paid immediately
  def sync_automatic
    return unless method == "automatic"

    update_column(:paid_at, created_at)
  end
end
