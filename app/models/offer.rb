class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }
  enum genre: { one_time: 1, monthly: 2, weekly: 3, daily: 4, regular: 5 }
end
