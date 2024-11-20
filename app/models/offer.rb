class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum status: { active: 1, inactive: 0 }
end
