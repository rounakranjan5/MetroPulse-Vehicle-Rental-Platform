class ChangeStationTypeToTextInRentalStations < ActiveRecord::Migration[8.0]
 def up
    change_column :rental_stations, :station_type, :text
  end

  def down
    # Assuming the original type was string or something else
    change_column :rental_stations, :station_type, :string
  end
end
