class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :name, presence: true, length: { maximum: 255 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :minimum_tickets, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :online_at, presence: true
  validates :offline_at, presence: true
  attribute :batch_count, :integer, default: 0
  attribute :minimum_tickets, :integer, default: 1
  enum status: { active: 1, inactive: 0 }

  mount_uploader :image, ImageUploader

  has_many :tickets
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  include AASM
  aasm column: :state do

    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting,
                  guard: :eligible_to_start?,
                  success: :update_value
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled,
                  success: :refund_coins
    end
  end

  def refund_coins
    self.tickets.each do |ticket|
      if ticket.may_cancel?
        ticket.cancel!
        ticket.save
      end
    end
    self.save
  end

  private

  def update_value
    deduct_quantity
    add_batch_count
  end

  def deduct_quantity
    self.update(quantity: self.quantity - 1)
  end

  def add_batch_count
    self.update(batch_count: self.batch_count + 1)
  end

  def eligible_to_start?
    self.quantity > 0 && self.offline_at > Time.current && self.active?
  end

  def destroy
    update(deleted_at: Time.current)
  end
end
