class Event < ActiveRecord::Base
  belongs_to :calendar

  def user
    self.calendar.user
  end

end
