def welcome
 puts "Hi, welcome"
end

def prompt_user
  users_array = User.all.map { |o| o.username} # move to method of User model
  users = ask("Select users: ", users_array) do |q|
    q.readline = true
  end
end

def options_prompt
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
