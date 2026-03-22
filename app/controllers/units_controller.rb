class UnitsController < ApplicationController
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

  # this creates the application
  def create
    Rails.logger.info "PARAMS: #{params.inspect}"
    @property = if params[:property_id].present?
                Property.find(params[:property_id])
              else
                Property.find(params[:unit][:property_id])
              end

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

    Rails.logger.info "UNIT BEFORE SAVE: #{@unit.inspect}"

    if @unit.save!
      redirect_to edit_unit_path(@unit),
        notice: "Unit created successfully."
    else
      Rails.logger.info "SAVE FAILED: #{@unit.errors.full_messages}"
      @properties = Property.all
      render :new, status: :unprocessable_entity
    end
  end

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

  def destroy
    @unit = Unit.find(params[:id])
    @property = @unit.property

    @unit.destroy

    redirect_to properties_path, notice: "Unit deleted successfully."
  end

end
