class Category < ApplicationRecord
  has_many :items, dependent: :restrict_with_error
  validates :name, presence: true

  has_many :item_category_ships
  has_many :items, through: :item_category_ships
end
