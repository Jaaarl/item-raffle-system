class Location < ApplicationRecord
  before_save :unset_other_locations_default, if: :is_default?

  default_scope { where(deleted_at: nil) }

  enum genre: { home: 0, work: 1 }

  validates :genre, presence: { message: I18n.t('location.validation.genre') }
  validates :name, presence: { message: I18n.t('location.validation.name') }
  validates :street_address, presence: { message: I18n.t('location.validation.street_address') }
  validates :phone_number, presence: true, phone: true
  validate :phone_number_is_valid

  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  has_many :winners

  def destroy
    update(deleted_at: Time.current)
  end

  private

  def unset_other_locations_default
    user.locations.where.not(id: id).update_all(is_default: false)
  end

  def phone_number_is_valid
    unless Phonelib.valid?(phone_number)
      errors.add(:phone_number, I18n.t('location.validation.phone_number_invalid'))
    end
  end
end
