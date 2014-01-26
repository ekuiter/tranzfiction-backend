class Authentication::RegistrationsController < Devise::RegistrationsController
  protected
  
  def after_inactive_sign_up_path_for(resource)
    # Login-Nachricht trotz Weiterleitung anzeigen (Nachricht über zwei Redirects speichern)
    session[:registration_flash] = flash[:notice] if flash[:notice]
    super
  end
end 