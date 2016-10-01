class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |table|
      table.string :event_name, null: false
      table.text :description, null: false
      table.string :location, null: false
      table.integer :user_id
    end
  end
end
