class LeaseAgreementsController < ApplicationController
  # all leases (for staff members/admin)
  def index
    @lease_agreements = Lease.all
  end

  # specific lease
  def show
    @lease_agreement = Lease.find(params[:id])
  end

  # activate
  def update
    lease = Lease.find(params[:id])
    lease.activate
  end
end
