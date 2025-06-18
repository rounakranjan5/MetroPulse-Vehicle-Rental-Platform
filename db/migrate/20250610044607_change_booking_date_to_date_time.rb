class ChangeBookingDateToDateTime < ActiveRecord::Migration[8.0]
  def up
    change_column :bookings, :booking_date, :datetime
  end

  def down
    change_column :bookings, :booking_date, :date
  end
end
