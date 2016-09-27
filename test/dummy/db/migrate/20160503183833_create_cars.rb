class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :child_id
      t.string  :child_type
  	  t.string :model
    end
  end
end
