class MaintenanceRequestsController < ApplicationController
  # list queue - this will auto prioritize
  def index
    @maintenance_requests = prioritize_queue
  end

  # display form for new request
  def new
    @request = MaintenanceRequest.new
  end

  # create request
  def create
    maintenance_request = MaintenanceRequest.new(
      priority: params[:maintenance_request][:priority],
      is_emergency: params[:maintenance_request][:is_emergency],
      maintenance_cost: params[:maintenance_request][:cost_to_tenant],
      tenant_caused: params[:maintenance_request][:tenant_caused],
      user_id: current_user.id,
      unit_id: params[:maintenance_request][:unit_id],
      status: "submitted"
    )
    ## CALL INVOICE
    maintenance_request.save!
  end

  # this is if a staff needs to alter the status of a request to be tenant caused
  def mark_tenant_caused
    maintenance_request = MaintenanceRequest.find(params[:id])
    ## CALL INVOICE
    maintenance_request.mark_tenant_caused
  end

  # ^^^ :)
  def close
    maintenance_request = MaintenanceRequest.find(params[:id])
    maintenance_request.close
  end

  private
  def prioritize_queue
    MaintenanceRequest.order(is_emergency: :desc, created_at: :asc)
  end
end
