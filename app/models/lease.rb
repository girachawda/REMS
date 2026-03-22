# The rental agreement between a tenant and a unit - needs both parties to sign
class Lease < ApplicationRecord
  belongs_to :user
  belongs_to :unit
  has_one :utility
  has_many :payments

  # Tenant signs their part of the lease
  def sign_as_tenant
    update!(
      tenant_signed: true
    )
    activate_if_complete
  end

  # Leasing agent signs their part of the lease
  def sign_as_agent
    update!(
      agent_signed: true
    )
    activate_if_complete
  end

  # Once both parties sign, the lease becomes active
  def activate_if_complete
    if tenant_signed && agent_signed
      update!(active: true)
    end
  end

  # Manually activate a lease (probably for special cases)
  def activate
    update!(active: true)
  end
end
