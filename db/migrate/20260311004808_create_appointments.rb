class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.references :availability, null: false, foreign_key: true
      t.datetime :scheduled_at
      t.integer :status

      t.timestamps
    end
  end
end
