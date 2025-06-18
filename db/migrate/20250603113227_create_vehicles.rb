class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :condition
      t.references :rental_station, null: false, foreign_key: true

      t.timestamps
    end
  end
end
