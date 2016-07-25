class Slot < ActiveRecord::Base
  has_many :park_records
  has_many :vehicles, through: :park_records
  belongs_to :location
  HOURLY_RATE = 3000

  scope :occupied, -> { where(is_occupied: true) }
  scope :free, -> { where(is_occupied: false) }
  scope :by_location, -> (location_id) { where("location_id = ?", "#{location_id}") }
end
