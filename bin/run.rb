require_relative '../config/environment'

def run
  system "clear"
  welcome
  choice = new_or_login_prompt
  case choice
    when :Quit
        system "clear"
        goodbye
    when :"New Account"
      system "clear"
      User.create_new_user
      run
    when :Login
      user = User.find_by(username: prompt_user)
      if auth(user)
        system "clear"
        puts ""
        puts ""
        main_menu(user)
      else
        system "clear"
        puts "TOO MANY INCORRECT LOGIN ATTEMPTS".colorize(:red)
        run
      end
  end
end

run
