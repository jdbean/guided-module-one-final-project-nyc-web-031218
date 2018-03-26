class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.integer :calendar_id
      t.integer :user_id #May become owner_id?
    end
  end
end
