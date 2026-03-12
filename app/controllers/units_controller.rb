class UnitsController < ApplicationController
  def show
    @property = Property.find(params[:property_id])
    @unit = @property.units.find(params[:id])
    @availabilities = Availability.where(property: @property).where("start_time >= ?", Time.now).order(:start_time)
  end
end
