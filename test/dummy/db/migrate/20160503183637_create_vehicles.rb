class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :mti_child_type
      t.integer :status
      t.integer :wheels
      t.timestamps null: false
    end
  end
end
