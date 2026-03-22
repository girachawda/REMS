class LeaseAgreementsController < ApplicationController
  # all leases (for staff members/admin)
  def index
    if current_user.leasing_agent?
      @lease_agreements = Lease.all
    else
      @lease_agreements = current_user.leases
    end
  end

  # specific lease
  def show
    @lease_agreement = Lease.find(params[:id])

    # autorenewal logic
    if Date.current > @lease_agreement.end_date
      if @lease_agreement.renewal_policy == "automatic"
        @lease_agreement.update_column(:end_date, @lease_agreement.end_date >> 12)
      else
        @lease_agreement.update_column(:active, false)
      end
    end
  end

  # activate
  def update
    lease = Lease.find(params[:id])
    lease.activate
  end

  def sign_tenant
    @lease = Lease.find(params[:id])
    @lease.sign_as_tenant

    redirect_to lease_agreement_path(@lease),
      notice: "You signed the lease."
  end

  def sign_agent
    @lease = Lease.find(params[:id])
    @lease.sign_as_agent

    redirect_to lease_agreement_path(@lease),
      notice: "Agent signed the lease."
  end
end
