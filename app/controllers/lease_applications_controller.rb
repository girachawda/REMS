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
    @application = RentalApplication.new
  end

  # this creates the application
  def create
    rental_application = RentalApplication.new(
      unit_id: params[:rental_application][:unit_id],
      start_date: params[:rental_application][:start_date],
      end_date: params[:rental_application][:end_date],
      duration: params[:rental_application][:duration],
      user: current_user,
      status: "pending"
    )
    rental_application.save!
  end

  # self explanatory lol
  def approve
    rental_application = RentalApplication.find(params[:id])
    rental_application.approve!
  end

  # also self explanatory
  def reject
    rental_application = RentalApplication.find(params[:id])
    rental_application.reject!(params[:rejection_reason])
  end
end
