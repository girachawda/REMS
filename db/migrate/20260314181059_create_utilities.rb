class CreateUtilities < ActiveRecord::Migration[7.2]
  def change
    create_table :utilities do |t|
      t.decimal :electricity_charges
      t.decimal :water_charges
      t.decimal :waste_management_charges
      t.references :lease, null: false, foreign_key: true

      t.timestamps
    end
  end
end
