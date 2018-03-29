def welcome
 puts "Hi! Welcome to the Agenda Manager CLI!".colorize(:green)
end

def new_or_login_prompt
  choose do |menu|
    menu.prompt = "Please select from above to create or login to your account:  ".colorize(:yellow)
    menu.choice(:Login)
    menu.choice(:"New Account")
    menu.choice(:Quit)
    menu.default = :Login
  end
end

def prompt_user
  users_array = User.all.map { |o| o.username}
  ask("Select user (press tab key to autocomplete): ".colorize(:yellow), users_array) do |q|
    q.readline = true
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

def main_menu(user)
  system "clear"
  puts "Welcome #{user.name}!".colorize(:green)
  menu = user.main_menu
  case menu
    when "Quit".colorize(:red)
      confirm_signout(user)
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
    when menu = :"Create Calendar"
      system "clear"
      user.new_calendar
      user.reload
      main_menu(user)
    when menu = :"Create Event"
      system "clear"
        if user.new_event == "Return Event"
          system "clear"
          main_menu(user)
        else
          user.reload
        end
    main_menu(user)
    when menu = :"Change User"
      confirm_signout(user)
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
    confirm_delete(user)
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
  system "clear"
  user.reload
  calendar = user.select_calendar_item(str)
  detail = calendar.calendar_detail_menu
  if detail == "Return to Main Menu".colorize(:green)
    system "clear"
    main_menu(user)
  elsif detail == "Delete Calendar".colorize(:red)
    confirm_delete(user)
    calendar.destroy
    user.reload
    system "clear"
    main_menu(user)
  elsif detail == "See All Events".colorize(:green)
    system "clear"
    cal_events = calendar.chronological_cal.map do |event|
      event.display_nicely
    end
    event_to_inspect = calendar.display_calendar_events(cal_events)
    if event_to_inspect == "Return to Main Menu".colorize(:green)
      system "clear"
      main_menu(user)
    else
      system "clear"
      view_event_detail(event_to_inspect, user)
    end
  else
    system "clear"
    updated_str = calendar.calendar_detail_edit(detail)
    view_calendar_detail(updated_str, user)
  end
end

def confirm_delete(user)
  confirm = ask("ARE YOU SURE YOU WANT TO DELETE THIS? ['y'/'n'] ".colorize(:red)) do |q|
    q.limit = 1
    q.validate = /[yn]/i
    q.responses[:not_valid] = "Invalid entry, please enter y or n."
  end
  main_menu(user) unless confirm.downcase == 'y'
end

def confirm_signout(user)
  confirm = ask("ARE YOU SURE YOU WANT TO SIGN OUT ['y'/'n'] ".colorize(:red)) do |q|
    q.limit = 1
    q.validate = /[yn]/i
    q.responses[:not_valid] = "Invalid entry, please enter y or n."
  end
  main_menu(user) unless confirm.downcase == 'y'
end

def goodbye
  puts "Thanks for using the Agenda Manager CLI!".colorize(:green)
  puts "Please come back soon to check your schedule!".colorize(:red)
  abort
end
