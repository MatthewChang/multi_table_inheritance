class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars, mti_child: true, extendable: true do |t|
      t.string :model
    end
  end
end
