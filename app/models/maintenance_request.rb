class MaintenanceRequest < ApplicationRecord
  belongs_to :unit
  belongs_to :user
  after_create :apply_to_balance

  def mark_tenant_caused
    update!(tenant_caused: true)
    apply_to_balance
  end

  def close
    update!(status: "closed")
  end

  def apply_to_balance
    if tenant_caused == true
      Invoice.create(
        account: user.account,
        lease: Lease.find_by(user: user, unit: unit, active: true),
        charge_type: "maintenance",
        total_charge: maintenance_cost,
        due_date: Date.current.end_of_month >> 1,
        status: "unpaid"
      )
    end
  end
end
