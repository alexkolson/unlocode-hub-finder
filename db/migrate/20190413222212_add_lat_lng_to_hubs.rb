class AddLatLngToHubs < ActiveRecord::Migration[5.2]
  def change
    add_column :hubs, :lat, :decimal
    add_column :hubs, :lng, :decimal
  end
end
