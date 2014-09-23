class Track < ActiveRecord::Base
  belongs_to :user
  has_many   :votes

  validates :title, :author, presence: true
  validates :url, 
            format: { with: URI.regexp, message: 'Please enter a valid URL'},
            allow_blank: true
end