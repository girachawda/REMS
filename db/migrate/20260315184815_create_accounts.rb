class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.decimal :balance, default: 0, precision: 15, scale: 2
      t.string :payment_cycle
      t.integer :bank_transfer_number
      t.decimal :discount_percent
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
