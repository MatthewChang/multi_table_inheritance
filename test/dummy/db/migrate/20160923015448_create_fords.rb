class CreateFords < ActiveRecord::Migration
  def change
    create_table :fords, mti_child: true, extendable: true  do |t|
      t.integer :year
    end
  end
end
