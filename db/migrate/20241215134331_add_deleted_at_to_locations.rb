class AddDeletedAtToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :deleted_at, :datetime, default: nil, index: true
  end
end
