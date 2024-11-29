class Banner < ApplicationRecord
  enum status: { inactive: 0, active: 1 }

  validates :image, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :status, presence: true

  mount_uploader :image, ImageUploader
end