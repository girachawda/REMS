class Invoice < ApplicationRecord
  belongs_to :lease
  belongs_to :account

  validates :charge_type, inclusion: { in: %w[utility rent maintenance] }
end
