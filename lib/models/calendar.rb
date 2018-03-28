class Calendar < ActiveRecord::Base
  has_many :events
  belongs_to :user

  def add_event
    entry = {}
    say("Enter the following information: ".colorize(:yellow))
    entry[:name] = ask("Name?  ".colorize(:yellow), String)
    entry[:description] = ask("Enter a description: ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
    end
    entry[:location] = ask("Enter a location: ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
    end
    entry[:start_time] = ask("Starting Time? ".colorize(:yellow), DateTime)
    entry[:end_time] = ask("Ending Time? ".colorize(:yellow), DateTime)
    entry[:calendar_id] = self.id
    Event.create(entry)

  end
end
