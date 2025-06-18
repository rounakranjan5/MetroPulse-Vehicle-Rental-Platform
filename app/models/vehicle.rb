class Vehicle < ApplicationRecord
  belongs_to :rental_station
  has_many :bookings
  
  validates :name, :condition, presence: true

  def average_rating
    completed_bookings = Booking.where(vehicle_id: id, status: "completed")
    ratings = completed_bookings.where.not(vehicle_rating: nil).pluck(:vehicle_rating)
    
    return 0 if ratings.empty?
    (ratings.sum.to_f / ratings.size).round(1)
  end
  
  def review_count
    Booking.where(vehicle_id: id, status: "completed").where.not(vehicle_rating: nil).count
  end
end
