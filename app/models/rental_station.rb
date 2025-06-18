class RentalStation < ApplicationRecord
  belongs_to :user
    
   
  has_many :vehicles, dependent: :destroy
  has_many :bookings, dependent: :destroy

  VALID_CITIES = [
    'Delhi NCR', 'Bangalore', 'Pune', 'Hyderabad', 'Dehradun', 
    'Kolkata', 'Chennai', 'Mumbai', 'Lucknow', 'Jaipur', 
    'Ahmedabad', 'Indore', 'Goa'
  ]

  validates :name, :station_type, presence: true

  validates :city, inclusion: { in: VALID_CITIES, message: "must be a valid city" }

  def average_rating
    completed_bookings = Booking.where(rental_station_id: id, status: "completed")
    ratings = completed_bookings.where.not(station_rating: nil).pluck(:station_rating)
    
    return 0 if ratings.empty?
    (ratings.sum.to_f / ratings.size).round(1)
  end
  
  def review_count
    Booking.where(rental_station_id: id, status: "completed").where.not(station_rating: nil).count
  end
end
