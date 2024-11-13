class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :name, presence: true, length: { maximum: 255 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :batch_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :minimum_tickets, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  enum status: { active: 0, inactive: 1 }

  mount_uploader :image, ImageUploader

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  include AASM
  aasm column: :state do

    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :paused, :ended, :cancelled], to: :starting,
                  guard: :can_start?,
                  success: :update_value
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

  def update_value
    self.update(quantity: self.quantity - 1)
    self.update(batch_count: self.batch_count + 1)
  end

  def can_start?
    self.quantity > 0 && self.offline_at > Time.current && self.status == "active"
  end
end
