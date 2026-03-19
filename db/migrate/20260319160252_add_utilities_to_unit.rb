class AddUtilitiesToUnit < ActiveRecord::Migration[7.2]
  def change
    add_reference :units, :utilities, foreign_key: true
  end
end
