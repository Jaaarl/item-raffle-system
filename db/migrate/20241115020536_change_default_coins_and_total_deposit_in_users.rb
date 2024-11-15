class ChangeDefaultCoinsAndTotalDepositInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :coins, 0
    change_column_default :users, :total_deposit, 0.0
  end
end
