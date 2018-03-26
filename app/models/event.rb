class Event < ActiveRecord::Base
  belongs_to :calendar
  belongs_to :User
end
