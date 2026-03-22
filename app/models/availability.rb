# Time slots when leasing agents are available to show properties
class Availability < ApplicationRecord
  belongs_to :user
  belongs_to :property
  has_many :appointments, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  # Basic sanity check - end time can't be before start time
  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
