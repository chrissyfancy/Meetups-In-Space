class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |table|
      table.integer :meetup_id
      table.integer :user_id
    end
  end
end
