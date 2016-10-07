class CreateExplorers < ActiveRecord::Migration
  def change
    create_table :explorers do |t|
      t.integer :mti_child_id
      t.string :mti_child_type
      t.string :driver
    end
  end
end
