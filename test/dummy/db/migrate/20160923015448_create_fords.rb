class CreateFords < ActiveRecord::Migration
  def change
    create_table :fords, id: false  do |t|
      t.integer :id, null: false, unique: true
      t.string :mti_child_type
      t.integer :year
    end
  end
end
