class Winner < ApplicationRecord
  belongs_to :tickets
  belongs_to :users
  belongs_to :items
  belongs_to :locations
  belongs_to :admin, class_name: 'User'
end
