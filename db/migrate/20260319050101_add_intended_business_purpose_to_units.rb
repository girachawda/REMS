class AddIntendedBusinessPurposeToUnits < ActiveRecord::Migration[7.2]
  def change
    add_column :units, :intended_business_purpose, :string
  end
end
