class Calendar < ActiveRecord::Base
  has_many :events
  belongs_to :user
  CALENDAR_KEY_ARRAY = [:name, :description, :color]

  def prepare_colors_string
    delete_array = [:black, :white, :light_white]
    custom_color_array = String.colors - delete_array
  end

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

  def calendar_detail_edit(detail)
    binding.pry
    key = detail.split(":")[0].downcase.to_sym
    entry = {}
    if key == :color
      colors = prepare_colors_string
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
  end

  def calendar_detail_menu
    system "clear"
    choose do |menu|
      menu.prompt = "Please select a field to edit above or type 1 to return to main menu:  ".colorize(:yellow)
      menu.choice("Return to Main Menu".colorize(:green))
      menu.choice("Delete Calendar".colorize(:red))
      CALENDAR_KEY_ARRAY.each do |s|
        menu.choice("#{s.id2name.capitalize}: #{self[s]}")
      end
    end

  end

end
