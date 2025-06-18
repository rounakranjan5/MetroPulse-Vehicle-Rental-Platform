class AddImageUrlToRentalStations < ActiveRecord::Migration[8.0]
  def change
    add_column :rental_stations, :image_url, :string
  end
end
