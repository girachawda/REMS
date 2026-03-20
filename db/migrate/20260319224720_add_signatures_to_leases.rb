class AddSignaturesToLeases < ActiveRecord::Migration[7.2]
  def change
    add_column :leases, :tenant_signed, :boolean, default: false
    add_column :leases, :agent_signed, :boolean, default: false
  end
end
