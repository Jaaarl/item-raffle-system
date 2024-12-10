class Banner < ApplicationRecord
  enum status: { inactive: 0, active: 1 }

  validates :image, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :status, presence: true
  validates :sort, presence: true, numericality: { greater_than: 0 }

  mount_uploader :image, ImageUploader
end