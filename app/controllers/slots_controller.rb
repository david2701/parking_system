class SlotsController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
    @slot_presenter = SlotPresenter.new(@location)
    @slot_presenter.build_slot_rows

    @slot_presenter.slots
    flash[:error] = 'No parking slots registered.' unless @slot_presenter.slots?
  end

  def new
    @location = Location.find(params[:location_id])
    @slot = Slot.new
  end

  def create
    @location = Location.find(params[:location_id])
    begin
      Slot.transaction do
        @slots_to_create = params[:slots].to_i
        @slots_to_create.times do
          @slot = Slot.new(is_occupied: 0, location_id: @location.id)
          unless @slot.save && @location.update_attributes(max_slots: @location.max_slots - 1)
            raise ActiveRecord::Rollback, "Slot could not be created."
          end
        end
        flash[:success] = 'Slots created successfully.'
        redirect_to location_slots_path(@location)
      end
    rescue
      flash[:error] = "Some errors when creating slots."
      render 'new'
    end
  end

  def edit
    @location = Location.find(params[:location_id])
    @slot = Slot.by_id(params[:id]).by_location(@location.id).first
  end

  def update
    @location = Location.find(params[:location_id])
    @slot = Slot.by_id(params[:id]).by_location(@location.id).first
    if @slot.update_attributes(slot_params)
      flash[:success] = 'Slot updated successfully.'
      redirect_to location_slots_path(@location)
    else
      flash[:error] = @slot.errors.full_messages.join(',')
      render 'edit'
    end
  end

  def destroy
    @location = Location.find(params[:location_id])
    @slot = Slot.by_id(params[:id]).by_location(@location.id).first
    if @slot.destroy
      flash[:success] = 'Slot deleted successfully.'
      redirect_to location_slots_path(@location)
    else
      flash[:error] = @slot.errors.full_messages.join(',')
      render 'index'
    end
  end

  def slot_params
    params.require(:slot).permit(:location_id, :id)
  end
  private :slot_params
end
