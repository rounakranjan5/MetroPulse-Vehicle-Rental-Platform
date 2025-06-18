# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_16_102312) do
  create_table "bookings", force: :cascade do |t|
    t.string "vehicle_type"
    t.integer "duration"
    t.decimal "price"
    t.datetime "booking_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rental_station_id", null: false
    t.integer "vehicle_id"
    t.integer "customer_id"
    t.integer "provider_id"
    t.string "booking_slot"
    t.integer "vehicle_rating"
    t.text "vehicle_review"
    t.integer "station_rating"
    t.text "station_review"
    t.datetime "reviewed_at"
    t.index ["rental_station_id"], name: "index_bookings_on_rental_station_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "status"
    t.integer "booking_id", null: false
    t.date "payment_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "rental_stations", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.text "station_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "image_url"
    t.index ["user_id"], name: "index_rental_stations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.string "condition"
    t.integer "rental_station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.decimal "price_per_hour"
    t.boolean "available"
    t.index ["rental_station_id"], name: "index_vehicles_on_rental_station_id"
  end

  add_foreign_key "bookings", "rental_stations"
  add_foreign_key "payments", "bookings"
  add_foreign_key "rental_stations", "users"
  add_foreign_key "vehicles", "rental_stations"
end
