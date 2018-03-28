class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars

  def auth
    password = ask("Enter your password:  ".colorize(:yellow)) { |q| q.echo = "*" }
    if password == self.password
      self
    else auth
    end
  end

  def calendars_to_name
    calendars.map { |c| c.name  }
  end

  def event_object_array_setup
    #{FIXME}EVENTS SHOULD BE AFTER TIME.NOW
    self.events.sort_by do |event|
      event.start_time
    end
  end

  def event_string_array_setup
    eve = event_object_array_setup
    eve[0..8].map do |event|
      "#{event.name} -- #{event.start_time.strftime("%H:%M")} (#{event.start_time.to_date}) to #{event.end_time.strftime("%H:%M")} (#{event.end_time.to_date}) - #{event.calendar.name}"
    end
  end

  def agenda_menu_prompt(strarr)
    choose do |menu|
      menu.prompt = "Please select from above or type 1 to return to main menu:  ".colorize(:yellow)
      #{FIXME} NEED better implementation for return to main menu"
      menu.choice(:"Return to Main Menu")
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
      menu.choice(:"New Calendar")
      menu.choice(:"Create Event")
      menu.choice(:"Change User")
      menu.choice(:Quit)
      # menu.default = :Login
    end
  end

  def prepare_colors_string
    delete_array = [:black, :white, :light_white]
    custom_color_array = String.colors - delete_array
  end

  def new_calendar
    #{FIXME} POTENTIALLY ALLOW TO GO BACK
      entry = {}
      say("Enter the following information: ".colorize(:yellow))
      entry[:name] = ask("Name? ".colorize(:yellow), String)
      entry[:description] = ask("Enter a description: ".colorize(:yellow), String) do |q|
        q.whitespace = :strip_and_collapse
      #{FIXME} Add :color entry and migration, Choose from String.colors array
      end
      entry[:user_id] = self.id
      colors = prepare_colors_string
      puts colors.map { |sym| sym.to_s.colorize(sym) }
      ask("Select calendar color (Press Tab to auto-complete): ".colorize(:yellow), colors) do |q|
        q.readline = true
      end
      Calendar.create(entry)
  end

  def which_calendar_to_add
    choose do |menu|
      menu.prompt = "Please select the calendar to add:  ".colorize(:yellow)
      calendars_to_name.each do |c|
        menu.choice(c)
      end
    end
  end

  def new_event
    cal = which_calendar_to_add
    int = calendars_to_name.index(cal)
    calendars[int].add_event
  end

  def self.create_new_user
    entry = {}
    say("Enter the following information: ".colorize(:yellow))
    entry[:name] = ask("Enter your name: ".colorize(:yellow))
    entry[:username] = ask("Enter a username: ".colorize(:yellow)) do |q|
      q.whitespace = :strip_and_collapse
    end
    entry[:password] = ask("Enter a password: ".colorize(:yellow))
    User.create(entry)
  end
end
