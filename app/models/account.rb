# Handles billing and payment info for each tenant
class Account < ApplicationRecord
  belongs_to :user
  has_many :invoices
  has_many :payments

  validates :user_id, uniqueness: true
  validates :payment_cycle, inclusion: { in: %w[monthly quarterly bi-annually annually] }

  # Calculate how much they pay based on their payment cycle (monthly vs quarterly etc)
  def pre_discount_payment_amount(rent)
    if payment_cycle == "monthly"
      rent
    elsif payment_cycle == "quarterly"
      rent * 3
    elsif payment_cycle == "bi-annually"
      rent * 6
    elsif payment_cycle == "annually"
      rent * 12
    end
  end

  # Apply any discounts to the rent amount
  def discounted_payment_amount(rent)
    if discount_percent > 0
     rent * (1 - (discount_percent / 100))
    else
      rent
    end
  end

  # Final amount for automatic payments - combines cycle multiplier and discount
  def automatic_payment_amount(rent)
    discounted_payment_amount(pre_discount_payment_amount(rent))
  end
end
