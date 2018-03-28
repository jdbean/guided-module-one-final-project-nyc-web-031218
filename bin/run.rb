require_relative '../config/environment'

def run
  choice = new_or_login_prompt
  case choice
    when :Quit
        goodbye
    when :"New Account"
      User.create_new_user
    when :Login
      # user = user_login
      user = User.find_by(username: prompt_user)
      if auth(user)
        main_menu(user)
      else
        puts "TOO MANY INCORRECT LOGIN ATTEMPTS".colorize(:red)
        run
      end
  end
end

welcome
run
