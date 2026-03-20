class UnitsController < ApplicationController
  def show
    @property = Property.find(params[:property_id])
    @unit = @property.units.find(params[:id])
    @availabilities = Availability.where(property: @property).where("start_time >= ?", Time.now).order(:start_time)
  end

  def new
    @unit = Unit.new
  end

  # this creates the application
  def create
    unit = Unit.new(
      property_id: params[:property_id],
      unit_number: params[:unit_number],
      size: params[:size],
      rental_rate: params[:rental_rate],
      classification: params[:classification],
      status: params[:status],
      intended_business_purpose: params[:intended_business_purpose],
    )
    unit.save!
  end

  def update
    @property = Property.find(params[:property_id])
    @unit = @property.units.find(params[:id])
    if @unit.update(
      property_id: params[:property_id],
      unit_number: params[:unit_number],
      size: params[:size],
      rental_rate: params[:rental_rate],
      classification: params[:rental_rate],
      status: params[:status],
      intended_business_purpose: params[:intended_business_purpose],
    )

    redirect_to unit_path(@unit), notice: "Unit updated"
    end
  end
end
