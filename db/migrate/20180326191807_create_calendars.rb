class CreateCalendars < ActiveRecord::Migration[5.0]
  def change
    create_table :calendars do |t|
      t.string :name
      t.string :unique_name
      t.string :description
    end
  end
end
