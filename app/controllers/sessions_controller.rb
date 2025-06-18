class SessionsController < MainController

    before_action :redirect_if_authenticated , except: [:destroy]

    def new

    end

    def create
        user=User.find_by(email: params[:email])

        if user.present? && user.authenticate(params[:password])
            session[:user_id]=user.id
            redirect_to root_path,notice:"Logged In Successfully"
        else
            flash[:alert]="Invalid Email or password"
            render :new
        end
    end

    def destroy
        session[:user_id]=nil
        redirect_to root_path,notice:"Logged Out Successfully"
    end

end
