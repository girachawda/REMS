class CreateLeases < ActiveRecord::Migration[7.2]
  def change
    create_table :leases do |t|
      t.integer :duration
      t.string :renewal_policy
      t.date :start_date
      t.date :end_date
      t.references :user, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
