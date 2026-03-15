class RenameCostToTenantOnMaintenanceRequest < ActiveRecord::Migration[7.2]
  def change
    rename_column :maintenance_requests, :cost_to_tenant, :maintenance_cost
  end
end
