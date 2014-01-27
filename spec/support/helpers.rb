def describe_actions(actions, &block)
  raise ArgumentError unless block
  actions.each do |action|
    describe action do
      instance_exec action, &block
    end
  end
end

def login(roles, &block)
  raise ArgumentError unless block
  if roles
    roles = [roles] unless roles.kind_of? Array
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