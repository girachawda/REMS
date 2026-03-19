class AddRenewalPolicyToRentalApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :rental_applications, :renewal_policy, :string
  end
end
