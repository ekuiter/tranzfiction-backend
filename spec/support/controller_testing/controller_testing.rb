module ControllerTesting
  include Authentication, ActionDescribe, ActionFetch, ActionStatus, ActionBehaviours
  
  def self.configure
    RSpec.configure do |config|
      # Methoden einbinden, die in "describe" und "context" aufrufbar sind
      config.extend ControllerTesting, type: :controller
      # Methoden einbinden, die in "it" und "let" aufrufbar sind
      config.include Helpers, type: :controller
    end
  end
end