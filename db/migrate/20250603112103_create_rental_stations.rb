class CreateRentalStations < ActiveRecord::Migration[8.0]
  def change
    create_table :rental_stations do |t|
      t.string :name
      t.string :city
      t.string :type
      t.string :status

      t.timestamps
    end
  end
end
