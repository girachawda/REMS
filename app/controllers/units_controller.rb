# Manage individual rental units (CRUD operations)
class UnitsController < ApplicationController
  # View a specific unit and available viewing times
  def show
    @property = Property.find(params[:property_id])
    @unit = @property.units.find(params[:id])
    @availabilities = Availability.where(property: @property).where("start_time >= ?", Time.now).order(:start_time)
  end

  def new
    @properties = Property.all
    @unit = Unit.new
  end

  def edit
    @unit = Unit.find(params[:id])
    @properties = Property.all
    @property = @unit.property
  end

  # Create a new unit in the system
  def create
    @property = Property.find(params[:unit][:property_id])

    @unit = Unit.new(
      property_id: @property.id,
      unit_number: params[:unit][:unit_number],
      size: params[:unit][:size],
      rental_rate: params[:unit][:rental_rate],
      classification: params[:unit][:classification],
      status: params[:unit][:status],
      intended_business_purpose: params[:unit][:intended_business_purpose],
      picture: params[:unit][:picture]
    )

    if @unit.save!
      redirect_to edit_unit_path(@unit),
        notice: "Unit created successfully."
    else
      Rails.logger.info "SAVE FAILED: #{@unit.errors.full_messages}"
      @properties = Property.all
      render :new, status: :unprocessable_entity
    end
  end

  # Update unit details (rent, size, status, etc)
  def update
    @unit = Unit.find(params[:id])
    @property = @unit.property

    if @unit.update!(
      unit_number: params[:unit][:unit_number],
      size: params[:unit][:size],
      rental_rate: params[:unit][:rental_rate],
      classification: params[:unit][:classification],
      status: params[:unit][:status],
      intended_business_purpose: params[:unit][:intended_business_purpose],
      picture: params[:unit][:picture]
    )

      redirect_to properties_path, notice: "Unit updated"
    else
      Rails.logger.info "SAVE FAILED: #{@unit.errors.full_messages}"
      @properties = Property.all
      render :new, status: :unprocessable_entity
    end
  end

  # Delete a unit from the system
  def destroy
    @unit = Unit.find(params[:id])
    @property = @unit.property

    @unit.destroy

    redirect_to properties_path, notice: "Unit deleted successfully."
  end
end
