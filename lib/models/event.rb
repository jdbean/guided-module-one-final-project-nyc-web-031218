class Event < ActiveRecord::Base
  belongs_to :calendar

  def user
    self.calendar.user
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
