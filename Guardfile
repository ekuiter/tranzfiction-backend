guard :rspec do
  # run every updated spec file
  watch(%r{^spec/.+_spec\.rb$})
 
  # run controller and model specs
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
 
  # run the integration specs related to the changed controller
  watch(%r{^app/controllers/(.+)\.rb}) { |m| "spec/requests/#{m[1]}_spec.rb" }
 
  # run all tests ...
  
  # when application controller change
  watch("app/controllers/application_controller.rb") { "spec" }
  
  # if spec_helper is changed
  watch("spec/spec_helper.rb")  { "spec" }
  
  # if the support files are changed
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  
  # if the routes are changed
  watch("config/routes.rb") { "spec/controller" }
end

