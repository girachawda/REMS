class CreateMaintenanceRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :maintenance_requests do |t|
      t.integer :priority
      t.boolean :is_emergency
      t.boolean :is_routine
      t.boolean :tenant_cause
      t.references :unit, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
