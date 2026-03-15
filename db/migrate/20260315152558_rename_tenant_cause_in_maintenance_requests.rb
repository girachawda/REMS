class RenameTenantCauseInMaintenanceRequests < ActiveRecord::Migration[7.2]
  def change
    rename_column :maintenance_requests, :tenant_cause, :tenant_caused
  end
end
