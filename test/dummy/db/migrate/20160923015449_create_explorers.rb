class CreateExplorers < ActiveRecord::Migration
  def change
    create_table :explorers, mti_child: true do |t|
      t.string :driver
    end
  end
end
