# Represents anyone using the system - tenants, leasing agents, or admin staff
class User < ApplicationRecord
  has_secure_password

  enum :role, { tenant: 0, leasing_agent: 1, administrative_staff: 2 }

  # Links to related data - accounts for billing, leases they've signed, applications submitted, etc.
  has_one :account
  has_many :leases
  has_many :rental_applications
  has_many :maintenance_requests
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
end
