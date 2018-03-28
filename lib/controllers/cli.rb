def welcome
 puts "Hi! Welcome to the agenda manager cli!".colorize(:green)
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



def goodbye
  puts "Thanks for using the Agenda Manager cli.".colorize(:green)
  puts "Please come back soon to check your schedule.".colorize(:red)
end

def user_login
   user = User.find_by(username: prompt_user)
   user.auth
end

def prompt_user
  users_array = User.all.map { |o| o.username} # move to method of User model
  ask("Select users: ".colorize(:yellow), users_array) do |q|
    q.readline = true
  end
end

def main_menu(user)
  puts "Welcome #{user.name}!".colorize(:green)
  menu = user.main_menu
  case menu
    when :Quit
      goodbye
    when menu = :"View Agenda"
      choice = user.view_agenda
      if choice == :"Return to Main Menu"
        main_menu(user)
      else
        view_event_detail(choice, user)
      end
    when menu = :"New Calendar"
      user.new_calendar
      user.save
      main_menu(user)
    when menu = :"Create Event"
      user.new_event
      user.save
      main_menu(user)
    when menu = :"Change User"
      run
  end
end

def view_event_detail(str, user)
  event = user.select_agenda_item(str)
  detail = event.detail_menu
  if detail == :"Return to Main Menu"
    main_menu(user)
  else
    updated_str = event.detail_edit(detail)
    view_event_detail(updated_str, user)
  end
end
