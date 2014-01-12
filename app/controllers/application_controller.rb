class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  around_filter :catch
  
  private
  
  def catch
    begin
      yield
    rescue ActiveRecord::RecordNotFound => e
      render json: "Diese ID existiert nicht"
    end
  end
  
  def admin
    render json: "Keine Berechtigung!" unless current_user.try(:admin?)
  end
end
