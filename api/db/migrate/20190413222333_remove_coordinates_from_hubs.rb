class RemoveCoordinatesFromHubs < ActiveRecord::Migration[5.2]
  def change
    remove_column :hubs, :coordinates, :point
  end
end
