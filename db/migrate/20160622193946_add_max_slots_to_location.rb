class AddMaxSlotsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :max_slots, :integer
  end
end
