require File.dirname(__FILE__) + '/../config/boot.rb'

disable :run

RSpec.configure do |config|
  config.before(:each) { Machinist.reset_before_test }
end


Server.blueprint do
end