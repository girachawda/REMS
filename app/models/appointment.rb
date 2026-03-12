class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :unit
  belongs_to :availability

  enum status: { pending: 0, confirmed: 1, cancelled: 2, completed: 3 }

  validates :scheduled_at, presence: true
  validates :status, presence: true
  validate :no_double_booking

  private

  def no_double_booking
    return if availability.blank? || scheduled_at.blank?

    existing = Appointment.where(availability_id: availability_id)
                         .where.not(id: id)
                         .where(status: [ :pending, :confirmed ])
                         .where(scheduled_at: scheduled_at)

    if existing.exists?
      errors.add(:scheduled_at, "is already booked")
    end
  end
end
