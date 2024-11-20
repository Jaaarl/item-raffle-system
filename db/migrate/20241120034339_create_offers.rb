class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :name
      t.integer :status
      t.decimal :amount, precision: 10, scale: 2
      t.integer :coin
      t.string :image

      t.timestamps
    end
  end
end
