class Ticket < ApplicationRecord
  before_create :update_value
  after_create :assign_serial_number
  belongs_to :user
  belongs_to :item
  belongs_to :winner

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled,
                  success: :refund_coins
    end
  end

  private

  def update_value
    deduct_coins
    assign_batch_count
  end

  def assign_batch_count
    self.batch_count = item.batch_count
  end

  def deduct_coins
    user.coins -= 1
    user.save
  end

  def refund_coins
    user.coins = user.coins + self.coins
    user.save
  end

  def assign_serial_number
    number_count = Ticket.where(item_id: item_id, batch_count: batch_count).count
    formatted_number_count = number_count.to_s.rjust(4, '0')
    time = Time.current.strftime("%y%m%d")
    self.serial_number = "#{time}-#{item.id}-#{item.batch_count}-#{formatted_number_count}"
  end
end
