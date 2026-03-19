class AddPicturesToUnits < ActiveRecord::Migration[7.2]
  def change
    add_column :units, :picture, :string
  end
end
