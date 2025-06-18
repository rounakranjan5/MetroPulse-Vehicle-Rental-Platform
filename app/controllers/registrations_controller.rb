class RegistrationsController < ApplicationController
  
    before_action :redirect_if_authenticated
    
    def new
        @user=User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id]=@user.id
            redirect_to root_path, notice: "Successfully Created Account"
        else
            
            flash[:alert]="Something went Wrong"
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role,:phone,:username)
    end

end

