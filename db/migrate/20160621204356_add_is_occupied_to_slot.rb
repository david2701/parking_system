class AddIsOccupiedToSlot < ActiveRecord::Migration
  def change
    add_column :slots, :is_occupied, :boolean
  end
end
