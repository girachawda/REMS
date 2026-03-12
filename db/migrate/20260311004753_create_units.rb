class CreateUnits < ActiveRecord::Migration[7.2]
  def change
    create_table :units do |t|
      t.references :property, null: false, foreign_key: true
      t.string :unit_number
      t.decimal :size
      t.decimal :rental_rate
      t.integer :classification
      t.integer :status

      t.timestamps
    end
  end
end
