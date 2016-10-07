class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :mti_child_id
      t.string  :mti_child_type
  	  t.string :model
    end
  end
end
