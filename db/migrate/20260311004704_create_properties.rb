class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :address
      t.text :description

      t.timestamps
    end
  end
end
