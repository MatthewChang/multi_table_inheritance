class CreateFords < ActiveRecord::Migration
  def change
    create_table :fords do |t|
      t.integer :mti_child_id
      t.string :mti_child_type
      t.integer :year
    end
  end
end
