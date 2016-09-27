class CreateFords < ActiveRecord::Migration
  def change
    create_table :fords do |t|
      t.integer :child_id
      t.string :child_type
      t.integer :year
    end
  end
end
