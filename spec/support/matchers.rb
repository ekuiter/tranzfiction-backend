def hash_from_json(json)
  hash = JSON.parse(json)
  if hash.respond_to? :except
    hash.except!("ready_in")
  end
end

def hash_from_model(model)
  hash = JSON.parse(model.to_json)
  if hash.respond_to? :except
    hash.except!("ready_in")
  end
end

RSpec::Matchers.define :be_json do |expected|
  match do |actual|
   begin
      if expected
        hash_from_json(actual) == hash_from_model(expected)
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