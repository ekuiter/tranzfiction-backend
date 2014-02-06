class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  around_filter :catch
  before_filter :permit, if: :devise_controller?
  
  private
  
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
