# app/controllers/language_controller.rb
class LanguageController < ApplicationController
  def switch
    locale = params[:locale].to_sym
    
    if I18n.available_locales.include?(locale)
      session[:locale] = locale
      
      # Store locale in cookie to persist between sessions (optional)
      cookies[:locale] = { value: locale, expires: 1.year.from_now }
    end
    
    redirect_back(fallback_location: root_path)
  end
end
