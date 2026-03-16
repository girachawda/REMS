# todo, missing intended business purpose
class Unit < ApplicationRecord
  belongs_to :property
  has_many :appointments, dependent: :destroy

  enum :classification, { tier_1: 0, tier_2: 1, tier_3: 2, tier_4: 3 }
  enum :status, { available: 0, occupied: 1, maintenance: 2 }

  validates :unit_number, presence: true
  validates :size, presence: true, numericality: { greater_than: 0 }
  validates :rental_rate, presence: true, numericality: { greater_than: 0 }
  validates :classification, presence: true
  validates :status, presence: true
end
