class Ticket < ApplicationRecord
  before_create :update

  belongs_to :user
  belongs_to :item

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
      transitions from: :pending, to: :cancelled
    end
  end

  def update
    self.batch_count = item.batch_count
    number_count = Ticket.where(item_id: item_id, batch_count: batch_count).count + 1
    formatted_number_count = number_count.to_s.rjust(4, '0')
    time = Time.current.strftime("%y%m%d")
    self.serial_number = "#{time}-#{item.id}-#{item.batch_count}-#{formatted_number_count}"
    user.coins -= 1
    user.save
  end
end
