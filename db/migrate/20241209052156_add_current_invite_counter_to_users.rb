class AddCurrentInviteCounterToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :current_invite_counter, :integer, default: 0
  end
end
