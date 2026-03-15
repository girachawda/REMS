class LeaseAgreementsController < ApplicationController
  # all leases (for staff members/admin)
  def index
    @lease_agreements = LeaseAgreement.all
  end

  # specific lease
  def show
    @lease_agreement = LeaseAgreement.find(params[:id])
  end

  # for the lease form
  def new
    @lease_agreement = LeaseAgreement.new
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
    lease.activate!
  end
end
