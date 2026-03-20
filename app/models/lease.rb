class Lease < ApplicationRecord
  belongs_to :user
  belongs_to :unit
  has_one :utility

  def sign_as_tenant
    update!(
      tenant_signed: true
    )
    activate_if_complete
  end

  def sign_as_agent
    update!(
      agent_signed: true
    )
    activate_if_complete
  end

  def activate_if_complete
    if tenant_signed && agent_signed
      update!(active: true)
    end
  end

  def activate
    update!(active: true)
  end
end
