class AddMemberLevelToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :member_level, null: true, foreign_key: true, default: 1
  end
end
