class LeaseAgreementsController < ApplicationController
  # all leases (for staff members/admin)
  def index
    @lease_agreements = Lease.all
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
    else
      @lease_agreement.update_column(:active, false)
    end
  end

  # activate
  def update
    lease = Lease.find(params[:id])
    lease.activate
  end
end
