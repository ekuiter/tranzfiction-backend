class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  around_filter :catch
  before_filter :permit, if: :devise_controller?
  
  if Rails.env.test?
    before_filter :authenticate_user!
  else
    before_filter :custom_authenticate_user!
  end
  
  private
  
  def custom_authenticate_user!
    if current_user
    elsif params[:controller].starts_with? "devise/" or params[:controller].starts_with? "authentication/"
    elsif params[:controller] == "meta" and params[:action] == "home"
      redirect_to new_user_session_path
    else
      begin
        user = User.where(email: params[:email]).first
        if user.valid_password?(params[:password])
          sign_in user, store: false
        else
          raise
        end
      rescue
        render text: "Nicht angemeldet", status: 401
      end
    end
  end
  
  def catch
    yield
  rescue ActiveRecord::RecordNotFound => e
    render json: "Diese ID existiert nicht", status: 404
  end
  
  def admin
    render json: "Keine Berechtigung!", status: 401 unless current_user.try(:admin?)
  end
  
  def permit
    [:sign_up, :account_update].each do |action|
      devise_parameter_sanitizer.for(action) << :planet
    end
  end
end
