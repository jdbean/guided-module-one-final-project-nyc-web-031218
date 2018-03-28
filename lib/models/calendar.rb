class Calendar < ActiveRecord::Base
  has_many :events
  belongs_to :user

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
end
