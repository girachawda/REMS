class AddUtilitiesToInvoices < ActiveRecord::Migration[7.2]
  def change
    add_column :invoices, :electricity_charges, :decimal, precision: 15, scale: 2
    add_column :invoices, :water_charges, :decimal, precision: 15, scale: 2
    add_column :invoices, :waste_management_charges, :decimal, precision: 15, scale: 2
  end
end
