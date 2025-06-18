class RenameTypeInRentalStationsToStationType < ActiveRecord::Migration[8.0]
  def change
      rename_column :rental_stations, :type, :station_type
  end
end
