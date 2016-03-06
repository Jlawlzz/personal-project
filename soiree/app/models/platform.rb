class Platform < ActiveRecord::Base
  has_many :tokens
  has_many :playlist
end
