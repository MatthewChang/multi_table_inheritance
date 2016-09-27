class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.integer :child_id
      t.string  :child_type
  	  t.integer :passengers
    end
  end
end
