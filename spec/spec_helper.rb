# frozen_string_literal: true

require_relative '../lib/app'
require 'rack/test'
require 'webmock/rspec'
require 'httparty'
require 'graphql'
require 'dotenv/load'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  WebMock.allow_net_connect!

  WebMock::API.prepend(Module.new do
    extend self
    def stub_request(*args)
      VCR.turn_off!
      super
    end
  end)

  config.before { VCR.turn_on! }
end
