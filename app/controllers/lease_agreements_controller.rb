# View and sign lease agreements
class LeaseAgreementsController < ApplicationController
  # Staff see all leases, tenants see only their own
  def index
    if current_user.leasing_agent?
      @lease_agreements = Lease.all
    else
      @lease_agreements = current_user.leases
    end
  end

  # View lease details and check for auto-renewal
  def show
    @lease_agreement = Lease.find(params[:id])

    # Check if lease expired and handle auto-renewal
    if Date.current > @lease_agreement.end_date
      if @lease_agreement.renewal_policy == "automatic"
        @lease_agreement.update_column(:end_date, @lease_agreement.end_date >> 12)
      else
        @lease_agreement.update_column(:active, false)
      end
    end
  end

  # Manually activate a lease
  def update
    lease = Lease.find(params[:id])
    lease.activate
  end

  # Tenant signs their part of the lease
  def sign_tenant
    @lease = Lease.find(params[:id])
    @lease.sign_as_tenant

    redirect_to lease_agreement_path(@lease),
      notice: "You signed the lease."
  end

  # Agent signs their part of the lease
  def sign_agent
    @lease = Lease.find(params[:id])
    @lease.sign_as_agent

    redirect_to lease_agreement_path(@lease),
      notice: "Agent signed the lease."
  end
end
