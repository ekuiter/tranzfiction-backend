module Authentication
  def login(*roles, &block)
    raise ArgumentError unless block
    if roles
      roles.each do |role|
        context "(#{role} logged in)" do
          let!(:user) { login(role) }
          instance_eval &block
        end
      end
    else
      context "(not logged in)" do
        instance_eval &block
      end
    end
  end

  def no_login(&block)
    login(nil, &block)
  end
end