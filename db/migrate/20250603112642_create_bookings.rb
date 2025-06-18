class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.string :vehicle_type
      t.integer :duration
      t.decimal :price
      t.date :booking_date
      t.string :status

      t.timestamps
    end
  end
end
