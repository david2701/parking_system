class CreateParkRecords < ActiveRecord::Migration
  def change
    create_table :park_records do |t|
      t.references :vehicle
      t.references :slot
      t.datetime :entry_date
      t.datetime :exit_date
      t.integer :total
      t.string :comments

      t.timestamps null: false
    end
  end
end
