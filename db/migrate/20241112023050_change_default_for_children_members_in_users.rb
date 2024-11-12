class ChangeDefaultForChildrenMembersInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :children_members, 0
  end
end
