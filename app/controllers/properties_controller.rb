class PropertiesController < ApplicationController
  def index
    @properties = Property.includes(:units).all

    # Search by name
    if params[:name].present?
      @properties = @properties.where("name LIKE ?", "%#{params[:name]}%")
    end

    # Search by location
    if params[:location].present?
      @properties = @properties.where("address LIKE ?", "%#{params[:location]}%")
    end

    # Filter by min size
    if params[:min_size].present?
      @properties = @properties.joins(:units).where("units.size >= ?", params[:min_size]).distinct
    end

    # Filter by max rental rate
    if params[:max_rate].present?
      @properties = @properties.joins(:units).where("units.rental_rate <= ?", params[:max_rate]).distinct
    end

    # Filter by classification
    if params[:classification].present?
      @properties = @properties.joins(:units).where("units.classification = ?", params[:classification]).distinct
    end

    # Filter by availability status
    if params[:status].present?
      @properties = @properties.joins(:units).where("units.status = ?", params[:status]).distinct
    end
  end

  def show
    @property = Property.find(params[:id])
    @units = @property.units
  end
end
