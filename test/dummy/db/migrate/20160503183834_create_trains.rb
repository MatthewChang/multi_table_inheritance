class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains, mti_child: true do |t|
  	  t.integer :passengers
    end
  end
end
