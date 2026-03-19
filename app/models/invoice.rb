class Invoice < ApplicationRecord
  belongs_to :lease
  belongs_to :account
  after_create :apply_to_balance

  validates :charge_type, inclusion: { in: %w[utility rent maintenance] }

  def apply_to_balance
    account.update_column(:balance, account.balance + total_charge)
  end
end
