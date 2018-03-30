class Calendar < ActiveRecord::Base
  has_many :events
  belongs_to :user
  CALENDAR_KEY_ARRAY = [:name, :description, :color]

  def prepare_colors_string
    delete_array = [:black, :white, :light_white, :default]
    custom_color_array = String.colors - delete_array
  end

  def chronological_cal
    events.sort_by {|e| e.start_time.in_time_zone('America/New_York')}
  end

  def add_event
    entry = {}
    say("Enter the following information: ".colorize(:yellow))
    puts ""
    entry[:name] = ask("Event Name:  ".colorize(:yellow), String)
    entry[:description] = ask("Event Description (limit 70 characters): ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
      q.limit = 70
    end
    entry[:location] = ask("Event Location: ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
    end
    entry[:start_time] = ask("Starting Time (YYYY/MM/DD HH:MM): ".colorize(:yellow), Time)
    entry[:end_time] = ask("Ending Time (YYYY/MM/DD HH:MM): ".colorize(:yellow), Time) {|q| q.above = entry[:start_time]}
    entry[:calendar_id] = self.id
    Event.create(entry)
  end

  def calendar_detail_menu
    prompt = TTY::Prompt.new
    prompt.select("Pease select an option from below to edit:  ".colorize(:yellow)) do |menu|
      menu.choice("Return to Main Menu".colorize(:green) => "Return to Main Menu".colorize(:green))
      menu.choice("See All Events".colorize(:green)=>"See All Events".colorize(:green))
      menu.choice("Delete Calendar".colorize(:red)=>"Delete Calendar".colorize(:red))
      CALENDAR_KEY_ARRAY.each do |s|
        menu.choice("#{s.id2name.capitalize}: #{self[s]}" => "#{s.id2name.capitalize}: #{self[s]}")
      end
    end
  end

  def display_calendar_events(cal_events)
    prompt = TTY::Prompt.new
    prompt.select("Pease select an option from below to edit:  ".colorize(:yellow)) do |menu|
      menu.choice("Return to Main Menu".colorize(:green) => "Return to Main Menu".colorize(:green))
      cal_events.each do |e|
        menu.choice(e => e)
      end
    end
  end

  def calendar_detail_edit(detail)
    key = detail.split(":")[0].downcase.to_sym
    entry = {}
    if key == :color
      colors = prepare_colors_string
      puts "Color Options:"
      puts "---------------"
      puts colors.map { |sym| sym.to_s.colorize(sym) }
      entry[:color] = ask("Select calendar color (Press Tab to auto-complete): ".colorize(:yellow), colors) do |q|
        q.readline = true
      end
    else
      say("Enter the new edit for '#{detail}'".colorize(:yellow))
      puts ""
      entry[key] = ask("New Edit: ".colorize(:yellow), self[key].class)
    end
    self.update(entry)
    self.reload
    return self.name
  end

end
