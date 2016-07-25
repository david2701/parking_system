class ParkRecordsController < ApplicationController
  before_action :vehicle, :slot, :location

  def index
    @park_record_presenter = ParkRecordPresenter.new(vehicles, slots, location)
    flash[:error] = 'No parking records registered for this location.' if @park_record_presenter.park_records_for_location.empty?
  end

  def simulate
    @park_record = ParkRecord.new
  end

  def park
    park_record_presenter = ParkRecordPresenter.new(vehicles, slots, location)
    if park_record_presenter.create_park_records
      flash[:success] = 'Parking Records created successfully.'
      redirect_to location_slots_path(@location)
    else  private :occupied_slots_for_location
      flash[:error] = "Some errors when creating parking records."
      render 'new'
    end
  end

  def edit

  end

  def leave
    park_record_presenter = ParkRecordPresenter.new(vehicles, slots, location)
    if park_record_presenter.update_park_records
      flash[:success] = 'Parking Records updated successfully.'
      redirect_to location_slots_path(@location)
    else
      flash[:error] = "Some errors when updating parking records."
      render 'index'
    end
  end

  def location
    @location = Location.find_by_id(params[:location_id])
  end
  private :location

  def vehicle
    @vehicle = Vehicle.find_by_id(params[:vehicle_id]) if params[:vehicle_id]
  end
  private :vehicle

  def slot
    @slot = Slot.find_by_id(params[:slot_id]) if params[:slot_id]
  end
  private :slot

  def slots
    @slots ||= Slot.by_location(location.id)
  end
  private :slots

  def vehicles
    @vehicles ||= Vehicle.all
  end
  private :vehicles

  def park_record_params
    params.require(:park_record).permit(:id,
                                        :vehicle_id,
                                        :slot_id,
                                        :entry_date,
                                        :exit_date,
                                        :comments,
                                        :total)
  end
  private :park_record_params
end
