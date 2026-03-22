class MaintenanceRequestsController < ApplicationController
  # list queue - this will auto prioritize
  def index
    if current_user.tenant?
      @maintenance_requests = current_user.maintenance_requests
    else
      @maintenance_requests = MaintenanceRequest.all
    end

    @maintenance_requests = @maintenance_requests.order(Arel.sql("CASE WHEN status = 'closed' THEN 1 ELSE 0 END"), is_emergency: :desc, created_at: :asc)
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

  def update_cost
    maintenance_request = MaintenanceRequest.find(params[:id])

    if maintenance_request.update(
      maintenance_cost: params[:maintenance_cost],
      tenant_caused: params[:tenant_caused].present?
    )
      maintenance_request.apply_to_balance if maintenance_request.tenant_caused?

      redirect_to maintenance_requests_path, notice: "Maintenance request updated."
    else
      redirect_to maintenance_requests_path, alert: maintenance_request.errors.full_messages.join(", ")
    end
  end

  # this is if a staff needs to alter the status of a request to be tenant caused
  def mark_tenant_caused
    maintenance_request = MaintenanceRequest.find(params[:id])
    maintenance_request.mark_tenant_caused

    redirect_to maintenance_requests_path, notice: "Marked as tenant caused."
  end

  # ^^^ :)
  def close
    maintenance_request = MaintenanceRequest.find(params[:id])
    maintenance_request.close
    redirect_to maintenance_requests_path, notice: "Maintenance request closed."
  end

  private
  def prioritize_queue
    MaintenanceRequest.order(is_emergency: :desc, created_at: :asc)
  end
end
