class Meetup < ActiveRecord::Base
  validates :event_name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :user_id, numericality: true
  has_many :users, through: :events
end
