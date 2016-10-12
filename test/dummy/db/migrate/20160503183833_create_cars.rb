class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars, id: false do |t|
      t.integer :id, null: false, unique: true
      t.string  :mti_child_type
  	  t.string :model
    end
  end
end
