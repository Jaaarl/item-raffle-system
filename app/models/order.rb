class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :offer

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :paid, :cancelled

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end
  end
end