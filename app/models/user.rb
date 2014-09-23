class User < ActiveRecord::Base
  has_many :tracks
  
  validates :name, :email, :password, presence: true
end