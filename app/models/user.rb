class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :places
  has_many :children, class_name: 'User', foreign_key: 'parent_id', dependent: :nullify
  belongs_to :parent, class_name: 'User', optional: true
  enum role: { client: 0, admin: 1 }
  mount_uploader :image, ImageUploader
  validates :phone, phone: true, allow_blank: true
end
