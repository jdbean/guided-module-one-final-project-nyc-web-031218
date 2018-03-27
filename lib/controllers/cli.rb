def welcome
 puts "Hi! Welcome to the agenda manager cli!"
end

def new_or_login_prompt
  choose do |menu|
    menu.prompt = "Please select from below to create or login to your account  "

    menu.choice(:"New Account")
    menu.choice(:Login)
    menu.choice(:Quit)
    menu.default = :Login
  end
end



def goodbye
  puts "Thanks for using the Agenda Manager cli."
  puts "Please come back soon to check your schedule."
end

def user_login
   User.find_by(username: prompt_user)
end

def prompt_user
  users_array = User.all.map { |o| o.username} # move to method of User model
  ask("Select users: ", users_array) do |q|
    q.readline = true
  end
end

def main_menu
  # Fill out prompt generic prompt options = view agenda, change user, quit, create calendar, create new event
end

def view_user_agenda(user)
  # gather's User's calendars
  # for each calendar, gather the 10 nearest of the calendar's events
  # capture the name, date, start_time, and end_time
  # format the captured date into a concise, attractive string ##(MAYBE calendar name also?)
  ## colorize strings according to calendar name?
  # present strings as options prompts to see more details, ##see_more or return to menu
end

def return_to_option_prompt
  # do we even need this?
end

def prompt_edit_or_return
  # agenda item details should prompt to edit or return to agenda
end

# def User.create_new_user
#
# end
