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

RSpec::Matchers.define :be_the_same_time_as do |expected|
  match do |actual|
    expected.to_i == actual.to_i
  end
end