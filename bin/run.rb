require_relative '../config/environment'

def run
  choice = new_or_login_prompt
  case choice
    when :Quit
      goodbye
    when :"New Account"
    User.create_new_user
    when :login
      user = prompt_user
      user = User.find_by(username: user)
      menu = user.main_menu
      case menu
        when :Quit
          goodbye
        when menu = :"View Agenda"
          user.view_agenda
        when menu = :"New Calendar"
          user.new_calendar
        when menu = :"Create Event"
          user.create_new_event
        when menu = :"Change User"
          #THIS OPTION NEEDS TO RESTART THE RUN COMMAND FLOW
      end
    end
end

welcome
run
