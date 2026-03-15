class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.decimal :total_charge
      t.date :due_date
      t.string :status
      t.references :lease, null: false, foreign_key: true

      t.timestamps
    end
  end
end
