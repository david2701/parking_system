class ParkRecordPresenter
  delegate :name, to: :location
  attr_accessor :location, :slots

  def initialize(vehicles, slots, location)
    @vehicles = vehicles
    @slots = slots
    @location = location
    @created = true
    @updated = true
  end

  def create_park_records
    ParkRecord.transaction do
      @vehicles.each do |vehicle|
        @slots.each do |slot|
          # Moves to the next free slot
          next if slot.is_occupied
          # does not create a park record
          # if the vehicle is occupying the slot
          next if any_slot_occupied_by_vehicle?(vehicle)
          @park_record = ParkRecord.new(vehicle_id: vehicle.id,
                                        slot_id: slot.id,
                                        entry_date: DateTime.now)
          unless @park_record.save && slot.update_attributes(is_occupied: true)
            @created = false
            raise ActiveRecord::Rollback, 'Parking Record could not be created.'
          end
        end
      end
    end
    @created
  end

  def update_park_records
    ParkRecord.transaction do
      @slots.each do |slot|
        # Moves to the next busy slot
        next unless slot.is_occupied
        park_records = occupied_park_records_by_slot[slot.id]
        park_records.each do |park_record|
          total = park_record.calculate_total
          unless park_record.update_attributes(exit_date: DateTime.now, total: total) && slot.update_attributes(is_occupied: false)
            @updated = false
            raise ActiveRecord::Rollback, 'Parking Record could not be updated.'
          end
        end
      end
    end
    @updated
  end

  def park_records_for_location
    @park_records_for_location ||= ParkRecord.by_location(@location.id)
  end

  def total_ammount_for_location
    @total_ammount_for_location ||= ParkRecord.total_for_location(@location.id)
  end

  def total_vehicles_for_location
    @total_vehicles_for_location ||= ParkRecord.total_vehicles_for_location(@location.id)
  end

  def occupied_slots_for_location
    @occupied_slots_for_location ||= Slot.by_location(@location.id).occupied
  end

  def empty_slots_for_location
    @empty_slots_for_location ||= Slot.by_location(@location.id).free
  end

  def occupied_park_records_by_slot
    @occupied_park_records_by_slot ||= occupied_slots_for_location.each_with_object({}) do |slot, memo|
      memo[slot.id] = ParkRecord.by_slot(slot.id).occupied
    end
  end
  private :occupied_park_records_by_slot

  def any_slot_occupied_by_vehicle?(vehicle)
    occupied_park_records_by_vehicle[vehicle.id].any?
  end
  private :any_slot_occupied_by_vehicle?

  def occupied_park_records_by_vehicle
    @occupied_park_records_by_vehicle ||= @vehicles.each_with_object({}) do |vehicle, memo|
      memo[vehicle.id] = ParkRecord.by_vehicle(vehicle.id).occupied
    end
  end
  private :occupied_park_records_by_vehicle
end
