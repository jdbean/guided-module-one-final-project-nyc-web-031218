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
      main_menu(user)
  end
end

welcome
run
