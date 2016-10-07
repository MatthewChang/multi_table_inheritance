class AddIndexToVehicles < ActiveRecord::Migration
  def change
    add_index(:vehicles, [:mti_child_id, :mti_child_type], unique: true)
  end
end
