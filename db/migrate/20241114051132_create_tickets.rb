class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :batch_count, null: false
      t.integer :coins, default: 1
      t.string :state
      t.string :serial_number

      t.timestamps
    end
  end
end
