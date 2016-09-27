class CreateExplorers < ActiveRecord::Migration
  def change
    create_table :explorers do |t|
      t.integer :child_id
      t.string :child_type
      t.string :driver
    end
  end
end
