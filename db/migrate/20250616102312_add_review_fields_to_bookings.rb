class AddReviewFieldsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :vehicle_rating, :integer
    add_column :bookings, :vehicle_review, :text
    add_column :bookings, :station_rating, :integer
    add_column :bookings, :station_review, :text
    add_column :bookings, :reviewed_at, :datetime

  end
end
