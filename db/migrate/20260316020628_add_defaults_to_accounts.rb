class AddDefaultsToAccounts < ActiveRecord::Migration[7.2]
  def change
    change_column_default :accounts, :payment_cycle, "monthly"
    change_column_default :accounts, :discount_percent, 0
  end
end
