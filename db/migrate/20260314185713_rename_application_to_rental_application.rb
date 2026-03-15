class RenameApplicationToRentalApplication < ActiveRecord::Migration[7.2]
  def change
    rename_table :applications, :rental_applications
  end
end
