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

  # for the lease form
  def new
    @lease_agreement = Lease.new
  end

  # this generates the lease agreement
  def create
    rental_application = RentalApplication.find(params[:id])
    if rental_application.status == "approved"
      lease = Lease.new(
        user: rental_application.user,
        unit: rental_application.unit,
        start_date: rental_application.start_date,
        end_date: rental_application.end_date,
        duration: rental_application.duration,
        renewal_policy: params[:renewal_policy]
      )
      lease.save!
    end
  end

  # activate
  def update
    lease = Lease.find(params[:id])
    lease.activate
  end
end
