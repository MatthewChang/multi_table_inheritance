class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles, extendable: true do |t|
      t.integer :status
      t.integer :wheels
      t.timestamps null: false
    end
  end
end
