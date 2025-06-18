class AddUserIdToRentalStations < ActiveRecord::Migration[8.0]
  def change
    add_reference :rental_stations, :user, null: false, foreign_key: true
  end
end
