class AddRentalStationIdToBookings < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookings, :rental_station, null: false, foreign_key: true
  end
end
