class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  enum status: { active: 0, inactive: 1 }

  mount_uploader :image, ImageUploader

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  include AASM
  aasm column: :state do

    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :paused, :ended, :cancelled], to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

end
