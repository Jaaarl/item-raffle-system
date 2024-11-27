class Order < ApplicationRecord
  include AASM

  after_create :assign_serial_number

  belongs_to :user
  belongs_to :offer

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :paid, :cancelled

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled,
                  success: :update_value_post_cancel
    end

    event :pay do
      transitions from: :submitted, to: :paid,
                  success: :update_value_post_paid
    end
  end

  private

  def update_value_post_paid
    if deduct?
      deduct_coins
    elsif deposit?
      increase_total_deposit
    else
      add_coins
    end
  end

  def update_value_post_cancel
    if deduct?
      add_coins
    elsif deposit?
      decrease_total_deposit
    elsif user.coins > self.coin
      deduct_coins
    end
  end

  def add_coins
    user.coins = user.coins + self.coin
    user.save
  end

  def deduct_coins
    user.coins -= self.coin
    user.save
  end

  def increase_total_deposit
    user.total_deposit += offer.amount
    user.save
  end

  def decrease_total_deposit
    user.total_deposit -= offer.amount
    user.save
  end

  def assign_serial_number
    number_count = Order.where(offer_id: offer_id, user_id: user_id).count
    formatted_number_count = number_count.to_s.rjust(4, '0')
    time = Time.current.strftime("%y%m%d")
    self.serial_number = "#{time}-#{self.id}-#{user_id}-#{formatted_number_count}"
  end
end