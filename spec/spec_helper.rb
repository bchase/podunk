require File.expand_path('../../lib/podunk.rb', __FILE__)

require 'rubygems'
require 'rspec'

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  # config.filter_run :focus => true
end
