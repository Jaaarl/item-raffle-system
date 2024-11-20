class Offer < ApplicationRecord
  enum status: { active: 1, inactive: 0 }

  mount_uploader :image, ImageUploader
end
