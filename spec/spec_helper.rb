require 'rspec'
require 'simplecov'
require 'coveralls'

SimpleCov.start do
  add_filter 'spec'
end

require 'spec/support/dummy_rails_form_builder'
require 'id'

RSpec.configure do |c|
  c.order = :rand
  c.mock_with :mocha
end
