class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  around_filter :catch
  
  private
  
  def catch
    yield
  rescue ActiveRecord::RecordNotFound => e
    render json: "Diese ID existiert nicht", status: 404
  end
  
  def admin
    render json: "Keine Berechtigung!", status: 401 unless current_user.try(:admin?)
  end
end
