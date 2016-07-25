class ParkRecord < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :slot

  scope :by_vehicle, -> (vehicle_id) { where("vehicle_id = ?", "#{vehicle_id}") }
  scope :by_slot, -> (slot_id) { where("slot_id = ?", "#{slot_id}") }
  scope :by_location, -> (location_id) { joins(:slot).where("slots.location_id = ?", "#{location_id}")}
  scope :occupied, -> { where(exit_date: nil) }

  def calculate_total
    current_date_time = DateTime.now
    ((current_date_time.to_i - entry_date.to_i) / 1.hours) * Slot::HOURLY_RATE
  end

  def self.total_for_location(location_id)
    by_location(location_id).sum(:total)
  end

  def self.total_vehicles_for_location(location_id)
    by_location(location_id).map(&:vehicle).uniq.count
  end

  def vehicle_vin
    vehicle.vin
  end

  def slot_id
    slot.id
  end
end
