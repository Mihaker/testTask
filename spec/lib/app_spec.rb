# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TestTaskApp, type: :controller do
  include Rack::Test::Methods

  def app
    TestTaskApp.new
  end

  describe '/set_name' do
    context 'when login valid' do
      it 'fetches user dat a from the API' do
        VCR.use_cassette('success_api_request') do
          get '/set_name', { login: 'mihaker' }

          expect(last_response).to be_ok
          expect(last_response.body).to include('Mykhailo Ostapenko')
          expect(last_response.body).to include('rozetka')
          expect(last_response.body).to include('Shop')
        end
      end
    end

    context 'when login null' do
      it 'try user dat a from the API' do
        VCR.use_cassette('error_api_request') do
          get '/set_name', { login: '' }

          expect(last_response).not_to be_ok
        end
      end
    end
  end
end
