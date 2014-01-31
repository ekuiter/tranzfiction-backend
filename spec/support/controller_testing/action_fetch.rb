module ActionFetch
  def get!(action=nil, &block)
    if block
      before { get((if action then action else self.class.description end), instance_eval(&block)) }
    else
      before { get (if action then action else self.class.description end) }
    end
    self
  end
end