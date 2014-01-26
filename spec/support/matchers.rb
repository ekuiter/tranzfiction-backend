RSpec::Matchers.define :be_json do |expected|
  match do |actual|
    begin
      JSON.parse(actual)
      if expected
        actual == expected.to_json
      else
        true
      end
    rescue
      false
    end
  end
end