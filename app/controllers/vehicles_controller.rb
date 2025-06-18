class VehiclesController < ApplicationController
    
    before_action :require_user_logged_in!
    before_action :require_provider!, except: [:index,:review]

    def index 
        @station = RentalStation.find(params[:id])
        @vehicles = @station.vehicles.paginate(page: params[:page], per_page: 6)

        if params[:search].present?
            search_term = "%#{params[:search].strip}%"
            @vehicles = @vehicles.where(
              "LOWER(name) LIKE ? OR LOWER(condition) LIKE ? OR LOWER(available) LIKE ? ", 
              search_term.downcase, search_term.downcase, search_term.downcase
            )
        end

    
    
        if params[:condition].present?
            @vehicles = @vehicles.where(condition: params[:condition])
        end
    
        if params[:status].present?
            @vehicles = @vehicles.where(available: params[:status])
        end


        if params[:min_price].present? && params[:max_price].present?
            @vehicles = @vehicles.where(price_per_hour: params[:min_price]..params[:max_price])
        elsif params[:min_price].present?
            @vehicles = @vehicles.where("price_per_hour >= ?", params[:min_price])
        elsif params[:max_price].present?
            @vehicles = @vehicles.where("price_per_hour <= ?", params[:max_price])
        end

    
        @vehicles = @vehicles.order(created_at: :asc)
        
    end

    def new 
        @station = RentalStation.find(params[:id])
        @vehicle = @station.vehicles.new
    end

    def create
        @station = RentalStation.find(params[:id])
        @vehicle = @station.vehicles.new(vehicle_params)
        
        if @vehicle.save
            redirect_to rental_station_vehicles_path(@station), notice: "Vehicle created successfully."
        else
            render :new, alert: "Failed to create vehicle."
        end
    end


    def edit
        @station = RentalStation.find(params[:id])
        @vehicle = @station.vehicles.find(params[:vehicle_id])
    end

    def update  
        @station = RentalStation.find(params[:id])
        @vehicle = @station.vehicles.find(params[:vehicle_id])
        if @vehicle.update(vehicle_params)
            redirect_to dashboard_my_vehicles_path(@station), notice: "Vehicle updated successfully."
        else
            render :edit, alert: "Failed to update vehicle."
        end
    end

    def destroy
        @station = RentalStation.find(params[:id])
        @vehicle = @station.vehicles.find(params[:vehicle_id])
        if @vehicle.destroy
            redirect_to rental_station_vehicles_path(@station), notice: "Vehicle deleted successfully."
        else
            redirect_to rental_station_vehicles_path(@station), alert: "Failed to delete vehicle."
        end
    end


    def review
  @vehicle = Vehicle.find(params[:id])
  
  @reviews = Booking.where(vehicle_id: @vehicle.id, status: "completed")
                   .where.not(vehicle_rating: nil)
                   .includes(:customer) 
                   .order(reviewed_at: :desc)
  
  
  @average_rating = @reviews.average(:vehicle_rating).to_f.round(1)
  @review_count = @reviews.count
    end


    private

    def vehicle_params
        params.require(:vehicle).permit(:name, :condition, :image_url, :rental_station_id, :price_per_hour,:available)
    end


end

