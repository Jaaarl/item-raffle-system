class ChangeAdminIdNullInWinners < ActiveRecord::Migration[7.0]
  def change
    change_column_null :winners, :admin_id, true
  end
end
