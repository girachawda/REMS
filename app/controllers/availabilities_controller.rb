# Leasing agents set their available time slots for showing properties
class AvailabilitiesController < ApplicationController
  before_action :require_login

  def index
    @availabilities = current_user.availabilities.order(start_time: :desc)
  end

  def new
    @availability = Availability.new
    @properties = Property.all
  end

  # Agent creates a time slot when they're available to show a property
  def create
    @availability = current_user.availabilities.build(availability_params)
    if @availability.save
      redirect_to availabilities_path, notice: "Availability created successfully"
    else
      @properties = Property.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def availability_params
    params.require(:availability).permit(:property_id, :start_time, :end_time)
  end
end
