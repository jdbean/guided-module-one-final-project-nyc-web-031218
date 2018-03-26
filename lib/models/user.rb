class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars

  def view_user_agenda
    self.events.each do |event|
      puts "#{event.name} -- #{event.start_time.strftime("%H:%M")} (#{event.start_time.to_date}) to #{event.end_time.strftime("%H:%M")} (#{event.end_time.to_date})"
    end
    return "WHAT SHOULD IT RETURN"
  end
end
