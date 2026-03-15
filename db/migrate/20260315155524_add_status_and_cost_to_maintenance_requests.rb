class AddStatusAndCostToMaintenanceRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :maintenance_requests, :status, :string
    add_column :maintenance_requests, :cost_to_tenant, :decimal
  end
end
