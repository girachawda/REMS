class RentalApplication < ApplicationRecord
  belongs_to :user
  belongs_to :unit

  scope :pending, -> { where(status: "pending") }

  def approve
    update!(status: "approved")
  end

  def reject(reason)
    update!(status: "rejected", rejection_reason: reason)
  end
end
