class ChangeBatchCountDefaultInTickets < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tickets, :batch_count, 0
  end
end
