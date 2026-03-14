class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.datetime :paid_at
      t.string :method
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
