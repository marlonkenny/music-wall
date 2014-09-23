class User < ActiveRecord::Base
  has_many :tracks
  has_many :votes
  
  validates :name, :email, :password, presence: true
end