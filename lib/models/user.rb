class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars

  def prepare_colors_string
    delete_array = [:black, :white, :light_white, :default]
    custom_color_array = String.colors - delete_array
  end

  def calendar_string_array_setup
    calendars.map { |c| c.name }
  end

  def calendars_to_name_colored
    calendars.map { |c| c.name.colorize(c.color.to_sym)  }
  end

  def event_object_array_setup
    future_events = self.events.select do |event|
      event.start_time.in_time_zone('America/New_York') > DateTime.now
    end
    future_events.sort_by do |event|
      event.start_time.in_time_zone('America/New_York')
    end
  end

  def all_event_object_array_setup
    events.sort_by do |event|
      event.start_time.in_time_zone('America/New_York')
    end
  end

  def event_string_array_setup
    eve = event_object_array_setup
    eve[0..9].map do |event|
      event.display_nicely
    end
  end

  def all_event_string_array_setup
    all_event_object_array_setup.map do |event|
      event.display_nicely
    end
  end

  def main_menu
    prompt = TTY::Prompt.new
      prompt.select ("Please select an option from below:  ".colorize(:yellow)) do |menu|
        menu.choice "View Agenda" => :"View Agenda"
        menu.choice "View Calendars" => :"View Calendars"
        menu.choice "Create Calendar" => :"Create Calendar"
        menu.choice "Create Event" => :"Create Event"
        menu.choice "Change User" => :"Change User"
        menu.choice "Quit".colorize(:red) => :"Quit"
      end
  end

  def view_agenda
    strarr = event_string_array_setup
    agenda_menu_prompt(strarr)
  end

  def agenda_menu_prompt(strarr)
    prompt = TTY::Prompt.new
    prompt.select ("Please select from above to edit or to return to main menu:  ".colorize(:yellow)) do |menu|
      menu.choice("Return to Main Menu".colorize(:green))
      strarr.each do |s|
        menu.choice(s => s)
      end
    end
  end

  def select_agenda_item(str)
    objarr = event_object_array_setup
    strarr = event_string_array_setup
    objarr[strarr.index(str)]
  end

  def select_all_agenda_item(str)
    objarr = all_event_object_array_setup
    strarr = all_event_string_array_setup
    objarr[strarr.index(str)]
  end

  def select_calendar_item(str)
    name = str.uncolorize
    self.calendars[self.calendar_string_array_setup.index(name)]
  end

  def display_calendars
    arr = calendars_to_name_colored
    prompt = TTY::Prompt.new
    prompt.select ("Please select from above to edit or to return to main menu:  ".colorize(:yellow)) do |menu|
      menu.choice("Return to Main Menu".colorize(:green))
      arr.each do |s|
        menu.choice(s => s)
      end
    end
  end

  def new_calendar
    entry = {}
    say("Enter the following information: ".colorize(:yellow))
    puts ""
    entry[:name] = ask("Calendar Name: ".colorize(:yellow), String)
    entry[:description] = ask("Calendar Description (limit 70 characters): ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
      q.limit = 70
    end
    entry[:user_id] = self.id
    colors = prepare_colors_string
    puts "Color Options:"
    puts "---------------"
    puts colors.map { |sym| sym.to_s.colorize(sym) }
    entry[:color] = ask("Calendar Color (Press Tab to auto-complete): ".colorize(:yellow), colors) do |q|
      q.readline = true
    end
    Calendar.create(entry)
  end

  def new_event
    cal = which_calendar_to_add
    if cal == "Return to Main Menu".colorize(:green)
      return "Return Event"
    else
      system "clear"
      int = calendars_to_name_colored.index(cal)
      calendars[int].add_event
    end
  end

  def which_calendar_to_add
    prompt = TTY::Prompt.new
    choose do |menu|
      menu.prompt = "Which calendar would you like to add this event to? ".colorize(:yellow)
      menu.choice("Return to Main Menu".colorize(:green))
      calendars_to_name_colored.each do |c|
        menu.choice(c)
      end
    end
  end

  def self.create_new_user
    users_array = User.all.map { |o| o.username}
    entry = {}
    say("Enter the following information: ".colorize(:yellow))
    puts ""
    entry[:name] = ask("Enter your name: ".colorize(:yellow), String)
    entry[:username] = ask("Enter a username: ".colorize(:yellow), String) do |q|
      q.whitespace = :strip_and_collapse
    end
    if users_array.include?(entry[:username])
      puts "Sorry. That username is already in use. Please try another username.".colorize(:red)
      sleep(1.5)
      system "clear"
      self.create_new_user
    else
    entry[:password] = ask("Enter a password: ".colorize(:yellow), String) { |q| q.echo = "*" }
    password = ask("Please confirm your password: ".colorize(:yellow), String) { |q| q.echo = "*" }
      if password != entry[:password]
        puts "Passwords do not match. Please try again.".colorize(:red)
        sleep(1.5)
        system "clear"
        self.create_new_user
      else
        User.create(entry)
      end
    end
  end

end
