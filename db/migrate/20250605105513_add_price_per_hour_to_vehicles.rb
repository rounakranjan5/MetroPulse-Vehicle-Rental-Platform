class AddPricePerHourToVehicles < ActiveRecord::Migration[8.0]
  def change
    add_column :vehicles, :price_per_hour, :decimal
  end
end
