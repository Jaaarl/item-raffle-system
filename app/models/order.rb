class Order < ApplicationRecord
  include AASM

  after_create :assign_serial_number

  belongs_to :user
  belongs_to :offer, optional: true

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4, member_level: 5 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :paid, :cancelled

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: :paid, to: :cancelled,
                  guard: :enough_coins?,
                  success: :update_value_post_cancel
      transitions from: [:pending, :submitted], to: :cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid,
                  success: :update_value_post_paid
      transitions from: :pending, to: :paid,
                  guard: :member_level?,
                  success: :add_coins
      transitions from: :pending, to: :paid,
                  guard: :bonus?,
                  success: :add_coins
      transitions from: :pending, to: :paid,
                  guard: :increase?,
                  success: :add_coins
      transitions from: :pending, to: :paid,
                  guard: :share?,
                  success: :add_coins
    end
  end

  private

  def update_value_post_paid
    if deduct?
      unless user.coins < self.coin
        deduct_coins
      end
    elsif deposit?
      increase_total_deposit
      add_coins
    end
  end

  def update_value_post_cancel
    if deduct?
      add_coins
    elsif deposit?
      decrease_total_deposit
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
    user.total_deposit += self.amount
    user.save
  end

  def decrease_total_deposit
    user.total_deposit -= self.amount
    user.save
  end

  def enough_coins?
    user.coins > self.coin
  end

  def assign_serial_number
    number_count = Order.where(offer_id: offer_id, user_id: user_id).count
    formatted_number_count = number_count.to_s.rjust(4, '0')
    time = Time.current.strftime("%y%m%d")
    self.serial_number = "#{time}-#{self.id}-#{user_id}-#{formatted_number_count}"
  end
end