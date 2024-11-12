class Item < ApplicationRecord
  enum status: { active: 0, inactive: 1}

  mount_uploader :image, ImageUploader
end
