class User < ApplicationRecord

    has_secure_password

    has_many :bookings_as_customer,class_name: 'Booking', foreign_key: 'customer_id'
    has_many :bookings_as_provider,class_name: 'Booking', foreign_key: 'provider_id'
    has_many :rental_stations, dependent: :destroy


    validates :username,presence: true,uniqueness: true

    validates :email,presence: true,format:{with: /\A[^@\s]+@[^@\s]+\z/,message:"must be a valid email address"}

    validates :phone,presence: true,length: { is: 10 },format: { with: /\A[6-9]\d{9}\z/, message: "is not a valid Indian phone number" }

end
