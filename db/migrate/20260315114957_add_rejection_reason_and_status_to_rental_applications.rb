class AddRejectionReasonAndStatusToRentalApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :rental_applications, :rejection_reason, :string
  end
end
