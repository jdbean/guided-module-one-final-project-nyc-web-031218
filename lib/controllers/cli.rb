def welcome
 puts "Hi! Welcome to the agenda manager CLI!".colorize(:green)
end

def new_or_login_prompt
  choose do |menu|
    menu.prompt = "Please select from above to create or login to your account:  ".colorize(:yellow)

    menu.choice(:"New Account")
    menu.choice(:Login)
    menu.choice(:Quit)
    menu.default = :Login
  end
end


def auth(user)
  counter = 3
  while counter > 0
    password = ask("Enter your password:  ".colorize(:yellow)) { |q| q.echo = "*" }
    if password == user.password
      return user
    end
    counter -= 1
  end
end

def goodbye
  puts "Thanks for using the Agenda Manager cli.".colorize(:green)
  puts "Please come back soon to check your schedule.".colorize(:red)
  abort
end

def prompt_user
  users_array = User.all.map { |o| o.username} # move to method of User model
  ask("Select user (press tab key to autocomplete): ".colorize(:yellow), users_array) do |q|
    q.readline = true
  end
end

def main_menu(user)
  puts "Welcome #{user.name}!".colorize(:green)
  menu = user.main_menu
  case menu
    when "Quit".colorize(:red)
      system "clear"
      goodbye
    when menu = :"View Agenda"
      system "clear"
      choice = user.view_agenda
      if choice == "Return to Main Menu".colorize(:green)
        system "clear"
        main_menu(user)
      else
        system "clear"
        view_event_detail(choice, user)
      end
    when menu =:"View Calendars"
      system "clear"
      choice = user.display_calendars
      if choice == "Return to Main Menu".colorize(:green)
        system "clear"
        main_menu(user)
      else
        system "clear"
        view_calendar_detail(choice, user)
        user.reload
        main_menu(user)
      end
    when menu = :"New Calendar"
      system "clear"
      user.new_calendar
      user.reload
      main_menu(user)
    when menu = :"Create Event"
      system "clear"
      user.new_event
      user.reload
      main_menu(user)
    when menu = :"Change User"
      system "clear"
      run
  end
end

def view_event_detail(str, user)
  event = user.select_agenda_item(str)
  detail = event.detail_menu
  if detail == "Return to Main Menu".colorize(:green)
    system "clear"
    main_menu(user)
  elsif detail == "Delete Event".colorize(:red)
    system "clear"
    event.destroy
    user.reload
    main_menu(user)
  else
    system "clear"
    updated_str = event.detail_edit(detail)
    system "clear"
    view_event_detail(updated_str, user)
  end
end

def view_calendar_detail(str, user)
  calendar = user.select_calendar_item(str)
  detail = calendar.calendar_detail_menu
  if detail == "Return to Main Menu".colorize(:green)
    system "clear"
    main_menu(user)
  elsif detail == "Delete Event".colorize(:red)
    calendar.destroy
    user.reload
    system "clear"
    main_menu(user)
  else
    system "clear"
    updated_str = calendar.calendar_detail_edit(detail)
    binding.pry
  end
end
