class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city

  has_many :Places, class_name: 'Place', foreign_key: 'address_barangay_id'
end
