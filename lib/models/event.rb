class Event < ActiveRecord::Base
  belongs_to :calendar

  KEY_ARRAY = [:name, :description, :location, :start_time, :end_time, :calendar]

  def user
    self.calendar.user
  end

  def put_event_detail_strings_in_array
    arr = []
    arr << "Name: #{self.name}"
    arr << "Description: #{self.description}"
    arr << "Location: #{self.location}"
    arr << "Start Time: #{self.start_time.strftime("%H:%M")} (#{self.start_time.to_date})"
    arr << "End Time: #{self.end_time.strftime("%H:%M")} (#{self.end_time.to_date})"
    arr << "Calendar: #{self.calendar.name}"
  end

  def display_nicely
    "#{self.name.colorize(self.calendar.color.to_sym)} -- #{self.start_time.strftime("%H:%M")} (#{self.start_time.to_date}) to #{self.end_time.strftime("%H:%M")} (#{self.end_time.to_date}) - #{self.calendar.name.colorize(self.calendar.color.to_sym)}"
  end

  def detail_edit(str)
    index = put_event_detail_strings_in_array.index(str)
    key = KEY_ARRAY[index]
    entry = {}
    say("Enter the new edit for '#{str}'".colorize(:yellow))
    if key == :end_time
      entry[key] = ask("(YYYY/MM/DD HH:MM)".colorize(:yellow), self[key].class){|q| q.above = self[:start_time]}
    elsif key == :calendar
      calendar = ask("Which calendar would you like to send this to? (Press tab for autocomplete) ".colorize(:yellow), user.calendar_string_array_setup)do |q|
        q.readline = true
      end
    entry[:calendar] = Calendar.find_by(:name => "#{calendar}")
    else
      entry[key] = ask("New Edit: ".colorize(:yellow), self[key].class)
    end
    self.update(entry)
    self.reload
    return "#{self.name.colorize(self.calendar.color.to_sym)} -- #{self.start_time.strftime("%H:%M")} (#{self.start_time.to_date}) to #{self.end_time.strftime("%H:%M")} (#{self.end_time.to_date}) - #{self.calendar.name.colorize(self.calendar.color.to_sym)}"
  end

  def detail_menu
    arr = put_event_detail_strings_in_array
    choose do |menu|
      menu.prompt = "Please select a field to edit above or type 1 to return to main menu:  ".colorize(:yellow)
      menu.choice("Return to Main Menu".colorize(:green))
      menu.choice("Delete Event".colorize(:red))
      arr.each do |s|
        menu.choice(s)
      end
    end
  end


end
