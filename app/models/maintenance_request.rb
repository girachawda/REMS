class MaintenanceRequest < ApplicationRecord
  belongs_to :unit
  belongs_to :user

  def mark_tenant_caused
    update!(tenant_caused: true)
  end

  def close
    update!(status: "closed")
  end
end
