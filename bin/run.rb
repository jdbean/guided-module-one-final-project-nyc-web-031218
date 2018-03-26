require_relative '../config/environment'

def run
  user = prompt_user
  user = User.find_by(username: user)
  options_prompt
  user.view_user_agenda
end

welcome
run
