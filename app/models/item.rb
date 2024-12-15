class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :name, presence: true, length: { maximum: 255 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :minimum_tickets, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :online_at, presence: true
  validates :offline_at, presence: true
  attribute :batch_count, :integer, default: 0
  attribute :minimum_tickets, :integer, default: 1
  enum status: { active: 1, inactive: 0 }

  mount_uploader :image, ImageUploader

  has_many :tickets
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :winners

  include AASM
  aasm column: :state do

    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting,
                  guard: :eligible_to_start?,
                  success: :update_quantity_and_batch_count
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended,
                  guard: :eligible_to_end?,
                  success: :set_winner
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

  def update_quantity_and_batch_count
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

  def eligible_to_end?
    self.tickets.where(batch_count: self.batch_count).count >= self.minimum_tickets
  end

  def set_winner
    winner = set_a_winner
    update_ticket(winner)
  end

  def set_a_winner
    winner = self.tickets.where(batch_count: self.batch_count).order("RAND()").first
  end

  def add_winner(ticket)
    Winner.create(
      ticket: ticket,
      user: ticket.user,
      item_batch_count: ticket.batch_count,
      item: ticket.item,
    )
  end

  def update_ticket(winner)
    tickets = self.tickets.where(batch_count: self.batch_count)
    tickets.each { |ticket| ticket.serial_number == winner.serial_number ? (ticket.win! && add_winner(ticket)) : ticket.lose! }
  end
end
