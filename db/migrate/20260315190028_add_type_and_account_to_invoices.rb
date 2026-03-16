class AddTypeAndAccountToInvoices < ActiveRecord::Migration[7.2]
  def change
    add_column :invoices, :type, :string
    add_reference :invoices, :account, null: false, foreign_key: true
  end
end
