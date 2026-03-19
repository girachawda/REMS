class LeaseApplicationsController < ApplicationController
  # this is to display all pending lease agreements
  def index
    @applications = RentalApplication.pending
  end

  def show
    @application = RentalApplication.find(params[:id])
  end

  # this is to display the form for application
  def new
    @unit = Unit.find(params[:unit_id])
    @application = RentalApplication.new(unit: @unit)
  end

  # this creates the application
  def create
    @application = RentalApplication.new(
      unit_id: params[:rental_application][:unit_id],
      start_date: params[:rental_application][:start_date],
      duration: params[:rental_application][:duration],
      renewal_policy: params[:rental_application][:renewal_policy],
      user: current_user,
      status: "pending"
    )

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

  # self explanatory lol
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

  # also self explanatory
  def reject
    rental_application = RentalApplication.find(params[:id])
    rental_application.reject(params[:rejection_reason])
  end
end
