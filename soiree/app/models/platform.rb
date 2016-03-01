class Platform < ActiveRecord::Base
  belongs_to :token
  belongs_to :user
end
