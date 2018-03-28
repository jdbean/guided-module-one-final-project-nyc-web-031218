require_relative '../config/environment'

def run
  system "clear"
  choice = new_or_login_prompt
  case choice
    when :Quit
        system "clear"
        goodbye
    when :"New Account"
      system "clear"
      User.create_new_user
      puts "==================="
      run
    when :Login
      user = User.find_by(username: prompt_user)
      if auth(user)
        system "clear"
        main_menu(user)
      else
        system "clear"
        puts "TOO MANY INCORRECT LOGIN ATTEMPTS".colorize(:red)
        puts "==================="
        run
      end
  end
end

welcome
run
