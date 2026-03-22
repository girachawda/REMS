# Handle rental applications (submit, approve, reject)
class LeaseApplicationsController < ApplicationController
  # Agents see pending applications, tenants see their own
  def index
    if current_user.leasing_agent?
      @applications = RentalApplication.pending
    else
      @applications = current_user.rental_applications
    end
  end

  def show
    @application = RentalApplication.find(params[:id])
  end

  def new
    @unit = Unit.find(params[:unit_id])
    @application = RentalApplication.new(unit: @unit)
  end

  # Tenant submits an application for a unit
  def create
    @application = RentalApplication.new(
      unit_id: params[:rental_application][:unit_id],
      start_date: params[:rental_application][:start_date],
      duration: params[:rental_application][:duration],
      renewal_policy: params[:rental_application][:renewal_policy],
      user: current_user,
      status: "pending"
    )

    # Calculate end date based on duration
    if @application.start_date.present? && @application.duration.present?
      @application.end_date = @application.start_date + @application.duration.months
    end

    if @application.save
      redirect_to lease_application_path(@application), notice: "Application submitted successfully."
    else
      @unit = Unit.find(@application.unit_id)
      render :new, status: :unprocessable_entity
    end
  end

  # Approve application and create the lease
  def approve
    @application = RentalApplication.find(params[:id])
    @application.update!(status: "approved")

    @lease = Lease.create!(
      user: @application.user,
      unit: @application.unit,
      start_date: @application.start_date,
      end_date: @application.end_date,
      duration: @application.duration,
      renewal_policy: @application.renewal_policy
    )

    @application.unit.update!(status: "occupied")

    redirect_to lease_agreement_path(@lease),
      notice: "Application approved and lease created."
  end

  # Reject application with a reason
  def reject
    @application = RentalApplication.find(params[:id])

    if request.patch?
      @application.reject(params[:rental_application][:rejection_reason])

      redirect_to lease_applications_path,
        notice: "Application rejected."
    end
  end
end
