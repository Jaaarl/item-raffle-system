class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  enum status: { active: 0, inactive: 1}

  mount_uploader :image, ImageUploader

  belongs_to :category
end
