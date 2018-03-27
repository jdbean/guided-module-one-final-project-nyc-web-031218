class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars

  def event_object_array_setup
    #{FIXME}EVENTS SHOULD BE AFTER TIME.NOW
    events.sort_by do |event|
      event.start_time
    end
  end

  def calendars_to_name
    calendars.map { |c| c.name  }
  end

  def event_string_array_setup
    eve = event_object_array_setup
    eve[0..9].map do |event|
      "#{event.name} -- #{event.start_time.strftime("%H:%M")} (#{event.start_time.to_date}) to #{event.end_time.strftime("%H:%M")} (#{event.end_time.to_date})"
    end
  end

  def agenda_menu_prompt(strarr)
    choose do |menu|
      menu.prompt = "Please select from above or type 1 to return to main menu:  "
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
    str = agenda_menu_prompt(strarr)
  end

  def select_agenda_item(str)
    objarr = event_object_array_setup
    strarr = event_string_array_setup
    event = objarr[event_string_to_index(str, strarr)]
    # event.detail_menu
  end

  def main_menu
    choose do |menu|
      menu.prompt = "Please select from above:  "

      menu.choice(:"View Agenda")
      menu.choice(:"New Calendar")
      menu.choice(:"Create Event")
      menu.choice(:"Change User")
      menu.choice(:Quit)
      # menu.default = :Login
    end
  end

  def new_calendar
    #{FIXME} POTENTIALLY ALLOW TO GO BACK
      entry = {}
      say("Enter the following information: ")
      entry[:name] = ask("Name? ")
      entry[:description] = ask("Enter a description: ") do |q|
        q.whitespace = :strip_and_collapse
      end
      entry[:user_id] = self.id
      Calendar.create(entry)
  end

  def which_calendar_to_add
    choose do |menu|
      menu.prompt = "Please select the calendar to add:  "
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
end
