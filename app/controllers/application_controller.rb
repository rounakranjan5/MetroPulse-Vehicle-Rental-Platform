class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user
  before_action :set_locale

  def set_current_user
        if session[:user_id]
            Current.user=User.find_by(id:session[:user_id])
        end
  end


  def require_user_logged_in!

    redirect_to sign_in_path,alert:"You must be signed in to do that" if Current.user.nil?
    
  end

  def require_provider!
    if Current.user.nil?
      redirect_to sign_in_path, alert: "You must be signed in to access this page."
    elsif Current.user.role != 'Provider'
      redirect_to root_path, alert: "You must be a provider to access this page." 
    end
  end

  def require_customer!
   if Current.user.nil?
      redirect_to sign_in_path, alert: "You must be signed in to access this page."
    elsif Current.user.role != 'Customer'
      redirect_to root_path, alert: "You must be a customer to access this page."
    end
  end

  def redirect_if_authenticated
    if Current.user
      redirect_to root_path, notice: "You are already signed in."
    end
  end

  private
  
  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end
  
  def extract_locale
    # Check for locale in session or cookie first
    locale_from_params_or_session = params[:locale] || session[:locale] || cookies[:locale]
    
    # Only return if it's a valid locale
    if locale_from_params_or_session && I18n.available_locales.include?(locale_from_params_or_session.to_sym)
      return locale_from_params_or_session.to_sym
    end
    
    # Optionally, get locale from Accept-Language header
    # browser_locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first&.to_sym
    # return browser_locale if browser_locale && I18n.available_locales.include?(browser_locale)
    
    nil
  end
end

