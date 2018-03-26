class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars
end
