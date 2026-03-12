class Property < ApplicationRecord
  has_many :units, dependent: :destroy
  has_many :availabilities, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
end
