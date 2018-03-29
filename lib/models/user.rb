class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars

  def calendars_to_name_colored
    calendars.map { |c| c.name.colorize(c.color.to_sym)  }
  end

  def calendar_string_array_setup
    calendars.map { |c| c.name }
  end

  def event_object_array_setup
    future_events = self.events.select do |event|
      event.start_time > DateTime.now
    end
    future_events.sort_by do |event|
      event.start_time
    end
  end

  def event_string_array_setup
    eve = event_object_array_setup
    eve[0..8].map do |event|
      event.display_nicely
    end
  end

  def agenda_menu_prompt(strarr)
    choose do |menu|
      menu.prompt = "Please select from above or type 1 to return to main menu:  ".colorize(:yellow)
      menu.choice("Return to Main Menu".colorize(:green))
      strarr.each do |s|
        menu.choice(s)
      end
    end
  end

  def event_string_to_index(str, strarr)
    strarr.index(str)
  end

  def view_agenda
    strarr = event_string_array_setup
    agenda_menu_prompt(strarr)
  end

  def select_agenda_item(str)
    objarr = event_object_array_setup
    strarr = event_string_array_setup
    objarr[event_string_to_index(str, strarr)]
  end

  def main_menu
    choose do |menu|
      menu.prompt = "Please select from above:  ".colorize(:yellow)
      menu.choice(:"View Agenda")
      menu.choice(:"View Calendars")
      menu.choice(:"Create Calendar")
      menu.choice(:"Create Event")
      menu.choice(:"Change User")
      menu.choice("Quit".colorize(:red))
    end
  end

  def prepare_colors_string
    delete_array = [:black, :white, :light_white]
    custom_color_array = String.colors - delete_array
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

  def which_calendar_to_add
    choose do |menu|
      menu.prompt = "Which calendar would you like to add this event to? ".colorize(:yellow)
      calendars_to_name_colored.each do |c|
        menu.choice(c)
      end
    end
  end

  def new_event
    cal = which_calendar_to_add
    int = calendars_to_name_colored.index(cal)
    calendars[int].add_event
  end

  def display_calendars
    arr = calendars_to_name_colored
    choose do |menu|
      menu.prompt = "Please select a field to edit above or type 1 to return to main menu:  ".colorize(:yellow)
      menu.choice("Return to Main Menu".colorize(:green))
      arr.each do |s|
        menu.choice(s)
      end
    end
  end

  def select_calendar_item(str)
    name = str.uncolorize
    self.calendars[self.calendar_string_array_setup.index(name)]
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
