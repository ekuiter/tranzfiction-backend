module ControllerMacros
  def login(role)
    if [:user, :admin].include? role
      @request.env["devise.mapping"] = Devise.mappings[role]
      user = FactoryGirl.create(role)
      sign_in :user, user
      user
    end
  end
end