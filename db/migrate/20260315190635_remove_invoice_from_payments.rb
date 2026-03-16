class RemoveInvoiceFromPayments < ActiveRecord::Migration[7.2]
  def change
    remove_reference :payments, :invoice, null: false, foreign_key: true
  end
end
