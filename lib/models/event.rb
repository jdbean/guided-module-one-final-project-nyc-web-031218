class Event < ActiveRecord::Base
  belongs_to :calendar

  def user
    self.calendar.user
  end

  def put_event_details_in_array
    arr = []
    arr << "Name: #{self.name}"
    arr << "Description: #{self.description}"
    arr << "Location: #{self.location}"
    arr << "Start Time: #{self.start_time.strftime("%H:%M")} (#{self.start_time.to_date})"
    arr << "End Time: #{self.end_time.strftime("%H:%M")} (#{self.end_time.to_date})"
    arr << "Calendar: #{self.calendar.name}"
  end

  def view_in_detail
    arr = put_event_details_in_array
    choose do |menu|
      menu.prompt = "Please select a field to edit above or type 1 to return to main menu:  "
      menu.choice(:"Return to Main Menu")
      arr.each do |s|
        menu.choice(s)
      end
    end
  end

  def edit_event
    hash = {self.name => "Name: #{self.name}",
    self.description => "Description: #{self.description}",
    self.location => "Location: #{self.location}",
    self.start_time => "Time: #{self.start_time} to #{self.end_time}",
    self.calendar => "Calendar: #{self.calendar.name}"}

    hash.each_with_index do |(key,value), index|
      puts "#{index + 1 }) #{value}"
    end
    puts "Which field would you like to edit?"
    num = STDIN.gets.chomp
  end


end
