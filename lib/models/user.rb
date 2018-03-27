class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars

  def view_agenda
    eve = events.sort_by do |event|
      event.start_time
    end
    eve[0..9].each_with_index do |event, index|
      puts "#{index+1}) #{event.name} -- #{event.start_time.strftime("%H:%M")} (#{event.start_time.to_date}) to #{event.end_time.strftime("%H:%M")} (#{event.end_time.to_date})"
    end
    return eve
  end

  def view_in_detail(num)
    eve = events.sort_by do |event|
      event.start_time
    end
    chosen_event = eve[num-1]
    puts "Name: #{chosen_event.name}"
    puts "Description: #{chosen_event.description}"
    puts "Start Time: #{chosen_event.start_time.strftime("%H:%M")} (#{chosen_event.start_time.to_date})"
    puts "End Time: #{chosen_event.end_time.strftime("%H:%M")} (#{chosen_event.end_time.to_date})"
    return chosen_event
  end

  def main_menu
    choose do |menu|
      menu.prompt = "Please select from below  "

      menu.choice(:"View Agenda")
      menu.choice(:"New Calendar")
      menu.choice(:"Create Event")
      menu.choice(:"Change User")
      menu.choice(:Quit)
      # menu.default = :Login
    end
  end

end
