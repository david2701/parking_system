class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :model
      t.string :year
      t.string :vin
      t.references :user

      t.timestamps null: false
    end
  end
end
