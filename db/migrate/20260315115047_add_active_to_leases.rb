class AddActiveToLeases < ActiveRecord::Migration[7.2]
  def change
    add_column :leases, :active, :boolean
  end
end
