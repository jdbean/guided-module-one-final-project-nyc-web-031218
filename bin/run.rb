require_relative '../config/environment'

def run
  choice = new_or_login_prompt
  case choice
    when :Quit
      goodbye
    when :"New Account"
      User.create_new_user
    when :Login
      user = user_login
      menu = user.main_menu
      case menu
        when :Quit
          goodbye
        when menu = :"View Agenda"
          event = user.view_agenda
          if event != "Return to Main Menu"
            event.view_in_detail
          end
          #{FIXME} ready for implementation of control flow
        when menu = :"New Calendar"
          user.new_calendar
        when menu = :"Create Event"
          user.new_event
        when menu = :"Change User"
          run
      end
    end
end

welcome
run
