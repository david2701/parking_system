class LocationsController < ApplicationController
  def index
    @locations = Location.all
    flash[:error] = 'No locations registered.' if @locations.empty?
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = 'Location registered successfully.'
      redirect_to locations_path
    else
      flash[:error] = @location.errors.full_messages.join(',')
      render 'new'
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(location_params)
      flash[:success] = 'Location updated successfully.'
      redirect_to locations_path
    else
      flash[:error] = @location.errors.full_messages.join(',')
      render 'edit'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    if @location.destroy
      flash[:success] = 'Location deleted successfully.'
      redirect_to locations_path
    else
      flash[:error] = @location.errors.full_messages.join(',')
      render 'index'
    end
  end

  def location_params
    params.require(:location).permit(:id, :name, :latitude, :longitude, :address, :max_slots, :description)
  end
  private :location_params
end
