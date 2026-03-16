class User < ApplicationRecord
  has_secure_password

  enum :role, { tenant: 0, leasing_agent: 1, administrative_staff: 2 }

  has_one :account
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
end
