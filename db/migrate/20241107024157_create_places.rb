class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.integer :genre, default: 0, null: false
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.text :remark
      t.boolean :is_default, default: false, null: false
      t.references :user, foreign_key: true, null: false
      t.references :address_region, foreign_key: true, null: false
      t.references :address_province, foreign_key: true, null: false
      t.references :address_city, foreign_key: true, null: false
      t.references :address_barangay, foreign_key: true, null: false

      t.timestamps
    end
  end
end
