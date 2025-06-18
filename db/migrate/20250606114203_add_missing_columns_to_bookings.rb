class AddMissingColumnsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :vehicle_id, :integer
    add_column :bookings, :customer_id, :integer
    add_column :bookings, :provider_id, :integer
  end
end
