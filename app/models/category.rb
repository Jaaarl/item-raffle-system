class Category < ApplicationRecord
  has_many :items, dependent: :restrict_with_error
end
