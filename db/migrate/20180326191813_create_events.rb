class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :location
      t.time :start_time
      t.time :end_time
      t.integer :calendar_id
    end
  end
end
