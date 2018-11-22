require 'bundler'
Bundler.require :default, :development
require 'pp'
require 'rspec/mocks'
require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

 config.raise_errors_for_deprecations!

  config.before(:each) do
    Metaforce.configuration.threading = false
    allow_any_instance_of(Metaforce::Job).to receive(:sleep)
  end
end

RSpec::Matchers.define :set_default do |option|
  chain :to do |value|
    @value = value
  end

  match do |configuration|
    @actual = configuration.send(option.to_sym)
    expect(@actual).to eq @value
  end

  failure_message do |configuration|
    "Expected #{option} to be set to #{@value.inspect}, got #{@actual.inspect}"
  end
end
