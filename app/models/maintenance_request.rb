class MaintenanceRequest < ApplicationRecord
  belongs_to :unit
  belongs_to :user

  def mark_tenant_caused
    update!(tenant_caused: true)
    apply_to_balance
  end

  def close
    update!(status: "closed")
  end

  def apply_to_balance
  return unless tenant_caused?
  return if maintenance_cost.blank? || maintenance_cost.to_f <= 0

  active_lease = Lease.find_by(user: user, unit: unit, active: true)
  return unless active_lease
  return unless user.account

  existing_invoice = Invoice.find_by(
    account: user.account,
    lease: active_lease,
    charge_type: "maintenance",
    total_charge: maintenance_cost,
    status: "unpaid"
  )
  return if existing_invoice.present?

  Invoice.create!(
    account: user.account,
    lease: active_lease,
    charge_type: "maintenance",
    total_charge: maintenance_cost,
    due_date: Date.current.end_of_month >> 1,
    status: "unpaid"
  )
end
    
end