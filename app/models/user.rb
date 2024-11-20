class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :locations
  has_many :children, class_name: 'User', foreign_key: 'parent_id', dependent: :nullify
  belongs_to :parent, class_name: 'User', optional: true, counter_cache: :children_members

  mount_uploader :image, ImageUploader

  enum role: { client: 0, admin: 1 }

  validates :phone, phone: true, allow_blank: true
end
