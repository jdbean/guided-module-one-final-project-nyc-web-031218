class CreateCalendars < ActiveRecord::Migration[5.0]
  def change
    create_table :calendars do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.string :color
    end
  end
end
