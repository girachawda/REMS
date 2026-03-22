# When tenants report issues with their unit (broken AC, leaky faucet, etc)
class MaintenanceRequest < ApplicationRecord
  belongs_to :unit
  belongs_to :user

  validates :unit_id, presence: true
  validates :priority, presence: true
  validate :request_type_selected

  # If tenant broke it, mark it and bill them
  def mark_tenant_caused
    update!(tenant_caused: true)
    apply_to_balance
  end

  # Close out a completed maintenance request
  def close
    update!(status: "closed")
  end

  # If tenant caused the issue, create an invoice to charge them for repairs
  def apply_to_balance
  return unless tenant_caused?
  return if maintenance_cost.blank? || maintenance_cost.to_f <= 0

  active_lease = Lease.find_by(user: user, unit: unit, active: true)
  return unless active_lease
  return unless user.account

  # Check if we already invoiced them for this to avoid duplicates
  existing_invoice = Invoice.find_by(
    account: user.account,
    lease: active_lease,
    charge_type: "maintenance",
    total_charge: maintenance_cost,
    status: "unpaid"
  )
  return if existing_invoice.present?

  # Create the invoice due next month
  Invoice.create!(
    account: user.account,
    lease: active_lease,
    charge_type: "maintenance",
    total_charge: maintenance_cost,
    due_date: Date.current.end_of_month >> 1,
    status: "unpaid"
  )
  end

  def request_type_selected
    unless is_emergency || is_routine
      errors.add(:base, "Please select emergency or routine")
    end
  end
end
