class User < ActiveRecord::Base
  has_many :calendars
  has_many :events, through: :calendars

  def view_user_agenda
    #COMPLETE ME
  end
end
