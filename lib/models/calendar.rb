class Calendar < ActiveRecord::Base
  has_many :events
  belongs_to :user

  def add_event
    entry = {}
    say("Enter the following information: ")
    entry[:name] = ask("Name?  ")
    entry[:description] = ask("Enter a description: ") do |q|
      q.whitespace = :strip_and_collapse
    end
    entry[:location] = ask("Enter a location: ") do |q|
      q.whitespace = :strip_and_collapse
    end
    entry[:start_time] = ask("Starting Time? ", DateTime)
    entry[:end_time] = ask("Ending Time? ", DateTime)
    entry[:calendar_id] = self.id
    Event.create(entry)

  end
end
