class NewsTicker < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  belongs_to :admin, class_name: 'User'

  enum status: { inactive: 0, active: 1 }

  validates :content, presence: true
  validates :status, presence: true

  def destroy
    update(deleted_at: Time.current)
  end
end