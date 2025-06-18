class Booking < ApplicationRecord
  belongs_to :rental_station
  belongs_to :vehicle, optional: true
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id', optional: true
  belongs_to :provider, class_name: 'User', foreign_key: 'provider_id', optional: true
  has_one :payment

  validates :vehicle_type, :duration, :price, :booking_date, presence: true
  validates :vehicle_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  validates :station_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  
  def reviewed?
    reviewed_at.present?
  end
  
  def reviewable?
    status == "completed" && !reviewed?
  end

  scope :pending,   -> { where(status: "pending") }
  scope :accepted,  -> { where(status: "accepted") }
  scope :completed, -> { where(status: "completed") }
  scope :canceled,  -> { where(status: "canceled") }
end
