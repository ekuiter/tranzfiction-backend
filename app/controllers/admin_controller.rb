class AdminController < ApplicationController
  before_filter :admin
  
  def admin
    redirect_to root_path, alert: "Keine Berechtigung!" unless current_user.try(:admin?)
  end
end
