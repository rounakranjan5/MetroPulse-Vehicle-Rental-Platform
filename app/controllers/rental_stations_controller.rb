class RentalStationsController < ApplicationController


  before_action :require_user_logged_in! 
  before_action :require_provider!, except: [ :all,:review]
  def new
    @rental_station = RentalStation.new
  end

  def create
    @rental_station = RentalStation.new(rental_station_params)
    @rental_station.user_id = Current.user.id  

    if @rental_station.save
      redirect_to dashboard_rental_stations_path, notice: "Rental station created successfully."
    else
      render :new, alert: "Failed to create rental station."
    end
  end

  def all
    @rental_stations = RentalStation.paginate(page: params[:page], per_page: 10).all


    
    if params[:search].present?
      search_term = "%#{params[:search].strip}%"
      @rental_stations = @rental_stations.where(
        "LOWER(name) LIKE ? OR LOWER(city) LIKE ? OR LOWER(station_type) LIKE ?", 
        search_term.downcase, search_term.downcase, search_term.downcase
      )
    end

    
    
    if params[:filter].present?
      @rental_stations = @rental_stations.where(station_type: params[:filter])
    end
    
    if params[:status].present?
      @rental_stations = @rental_stations.where(status: params[:status])
    end

    if params[:city].present?
      @rental_stations = @rental_stations.where(city: params[:city])
    end
    
    @rental_stations = @rental_stations.order(created_at: :asc)
  end
  
  def destroy
    @rental_station = RentalStation.find(params[:id])
    
    if @rental_station.user_id == Current.user.id
      @rental_station.destroy
      redirect_to dashboard_rental_stations_path, notice: "Rental station deleted successfully."
    else
      redirect_to dashboard_rental_stations_path, alert: "You are not authorized to delete this rental station."
    end
  end
  
  
def edit
@rental_station = RentalStation.find(params[:id])
  
   
end


def update
  @rental_station = RentalStation.find(params[:id])
  if @rental_station.user_id == Current.user.id
    if @rental_station.update(rental_station_params)
      redirect_to dashboard_rental_stations_path, notice: "Rental station updated successfully."  
    else
      render :edit, alert: "Failed to update rental station."
    end
  else
    redirect_to dashboard_rental_stations_path, alert: "You are not authorized to update this rental station."
  end
end


def review

  @rental_station = RentalStation.find(params[:id])
  
  @reviews = Booking.where(rental_station_id: @rental_station.id, status: "completed")
                    .where.not(station_rating: nil)
                    .includes(:customer) 
                    .order(reviewed_at: :desc)
  
  
  @average_rating = @reviews.average(:station_rating).to_f.round(1)
  @review_count = @reviews.count


end




  private
    def rental_station_params
      params.require(:rental_station).permit(:name, :city, :status, :image_url, :station_type)
    
    end

end
