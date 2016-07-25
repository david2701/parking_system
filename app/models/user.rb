class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :vehicles

  validates :first_name, presence: true, length: { maximum: 75 }
  validates :last_name, presence: true, length: { maximum: 75 }
  validates :password, presence: true, length: { maximum: 75}
  validates :email, presence: true, uniqueness: true, format:  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, length: { maximum: 254 }
  validates_date :birthdate, :on_or_before => lambda { Date.current }
end
