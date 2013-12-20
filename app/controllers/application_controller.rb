class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  http_basic_authenticate_with name: "sf", password: "sf256"
  
  before_filter :authenticate_user!
end
