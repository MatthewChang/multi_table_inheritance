class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.integer :mti_child_id
      t.string  :mti_child_type
  	  t.integer :passengers
    end
  end
end
