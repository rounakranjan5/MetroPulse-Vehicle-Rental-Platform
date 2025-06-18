class BookingsController < ApplicationController
  before_action :require_user_logged_in!
  before_action :require_customer! , except: [:accept, :complete, :cancel]
  
  def create
    vehicle_id = params[:vehicle_id]
    @vehicle = Vehicle.find(vehicle_id)
    @station = @vehicle.rental_station
    
    if @vehicle.available && @station.status == "Active"

      duration = params[:duration].to_i
      booking_slot = params[:booking_slot]
      
      
      @booking = Booking.create!(
        vehicle_id: @vehicle.id,
        rental_station_id: @station.id,
        customer_id: Current.user.id,
        provider_id: @station.user_id,
        vehicle_type: @vehicle.name,
        duration: duration,
        price: @vehicle.price_per_hour * duration,
        booking_date: Time.zone.now,
        booking_slot: booking_slot,
        status: "pending"
      )
      
      if @booking.persisted?
        @vehicle.update(available: false)
        redirect_to all_bookings_path, notice: "Booking requested for #{booking_slot}!"
      else
        redirect_to rental_station_vehicles_path(@station), alert: "Error creating booking."
      end
    else
      redirect_to rental_station_vehicles_path(@station), alert: "Vehicle not available."
    end
  end
  
  def accept
    @booking = Booking.find(params[:id])
    @booking.update(status: "accepted")
    redirect_to all_bookings_path, notice: "Booking accepted."
  end
  
  def complete
    @booking = Booking.find(params[:id])
    @booking.update(status: "completed")
    vehicle = Vehicle.find(@booking.vehicle_id)
    vehicle.update(available: true)
    redirect_to all_bookings_path, notice: "Ride completed."
  end
  
  def cancel
    @booking = Booking.find(params[:id])
    @booking.update(status: "canceled")
    vehicle = Vehicle.find(@booking.vehicle_id)
    vehicle.update(available: true)
    redirect_to all_bookings_path, notice: "Booking canceled."
  end
end
