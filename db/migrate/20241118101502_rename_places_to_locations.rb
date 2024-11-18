class RenamePlacesToLocations < ActiveRecord::Migration[7.0]
  def change
    rename_table :places, :locations
  end
end
