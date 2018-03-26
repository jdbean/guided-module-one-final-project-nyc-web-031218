user1 = User.create!(name: "Name1", username: "name1")
user2 = User.create!(name: "Name2", username: "name2")
user3 = User.create(name: "Name3", username: "name3")
user4 = User.create(name: "Name4", username: "name4")
user5 = User.create(name: "Name5", username: "name5")
user6 = User.create(name: "Name6", username: "name6")

calendar1 = Calendar.create(name: "Cal1", unique_name: "cal1", description: "This is cal1", user_id: 1)
calendar2 = Calendar.create(name: "Cal2", unique_name: "cal2", description: "This is cal2", user_id: 2)
calendar3 = Calendar.create(name: "Cal3", unique_name: "cal3", description: "This is cal3", user_id: 3)
calendar4 = Calendar.create(name: "Cal4", unique_name: "cal4", description: "This is cal4", user_id: 4)

event1 = Event.create(name: "Birthday", start_time: DateTime.new(2018, 3, 26.5),end_time: DateTime.new(2018, 3, 26.75), calendar_id: 1)
