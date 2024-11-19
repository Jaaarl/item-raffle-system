class ChangePriceNullConstraint < ActiveRecord::Migration[7.0]
  def change
    change_column_null :winners, :price, true
  end
end
