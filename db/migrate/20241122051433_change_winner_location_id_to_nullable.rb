class ChangeWinnerLocationIdToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :winners, :location_id, true
  end
end
