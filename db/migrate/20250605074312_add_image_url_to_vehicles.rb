class AddImageUrlToVehicles < ActiveRecord::Migration[8.0]
  def change
    add_column :vehicles, :image_url, :string
  end
end
