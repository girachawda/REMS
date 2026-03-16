class RenameTypeToChargeTypeInInvoices < ActiveRecord::Migration[7.2]
  def change
    rename_column :invoices, :type, :charge_type
  end
end
