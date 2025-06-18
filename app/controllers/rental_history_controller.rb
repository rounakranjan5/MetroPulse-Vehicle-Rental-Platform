class RentalHistoryController < ApplicationController

    before_action  :require_user_logged_in!

    def show
        if Current.user.role=='Provider'
            @completed_rentals=Booking.paginate(page: params[:page], per_page: 10).where(provider_id: Current.user.id, status: 'completed').order(created_at: :desc)
        else
            @completed_rentals=Booking.paginate(page: params[:page], per_page: 10).where(customer_id: Current.user.id, status: 'completed').order(created_at: :desc)
        end
    end

end

