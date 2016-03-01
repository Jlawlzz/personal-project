class Token < ActiveRecord::Base
  belongs_to :user
  belongs_to :platform
end
