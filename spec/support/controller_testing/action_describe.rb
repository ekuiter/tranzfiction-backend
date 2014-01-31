module ActionDescribe
  def describe_actions(*actions, &block)
    raise ArgumentError unless block || actions
    actions.each do |action|
      describe action do
        instance_exec(action, &block)
      end
    end
  end
end