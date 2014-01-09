class AjaxFailure < Devise::FailureApp

  def respond
    # if AJAX request and account unconfirmed
    if request.xhr? && warden_message == :unconfirmed
    else
      if http_auth?
          http_auth
        elsif warden_options[:recall]
          recall
        else
          redirect
      end 
    end
  end

end