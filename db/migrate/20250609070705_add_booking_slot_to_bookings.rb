class AddBookingSlotToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :booking_slot, :string
  end
end
