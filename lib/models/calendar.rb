class Calendar < ActiveRecord::Base
  has_many :events
  belongs_to :user
  CALENDAR_KEY_ARRAY = [:name, :description, :color]

  def add_event
    entry = {}
    say("Enter the following information: ".colorize(:yellow))
    puts ""
    entry[:name] = ask("Name?  ".colorize(:yellow), String)
    entry[:description] = ask("Enter a description (limit 70 characters): ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
      q.limit = 70
    end
    entry[:location] = ask("Enter a location: ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
    end
    entry[:start_time] = ask("Starting Time? (use format YYYY/MM/DD HH:MM) ".colorize(:yellow), DateTime)
    entry[:end_time] = ask("Ending Time? ".colorize(:yellow), DateTime) {|q| q.above = entry[:start_time]}
    entry[:calendar_id] = self.id
    Event.create(entry)
  end

  def calendar_detail_menu
    choose do |menu|
      menu.prompt = "Please select a field to edit above or type 1 to return to main menu:  ".colorize(:yellow)
      menu.choice("Return to Main Menu".colorize(:green))
      menu.choice("Delete Calendar".colorize(:red))
      CALENDAR_KEY_ARRAY.each do |s|
        menu.choice(s.id2name)
      end
    end
    
  end

end
