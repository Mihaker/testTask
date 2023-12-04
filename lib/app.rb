# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'dotenv/load'

require 'graphql'
require 'httparty'

GITHUB_TOKEN = ENV['GHP']

class TestTaskApp < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/set_name' do
    input_user = params['login']

    endpoint_url = 'https://api.github.com/graphql'

    query_string = <<~GRAPHQL
      query($login: String!) {
        user(login: $login) {
          name
          repositories(last: 10) {
            edges {
              node {
                name
              }
            }
          }
        }
      }
    GRAPHQL

    login = { 'login' => input_user }

    if input_user.nil? || input_user.empty?
      @error_message = "Помилка: параметр 'login' намає бути порожнім"
      erb :error_page
    else
      headers = {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{GITHUB_TOKEN}"
      }

      query_payload = {
        query: query_string,
        variables: login
      }

      response = HTTParty.post(endpoint_url, body: query_payload.to_json, headers: headers).parsed_response
  
      if response['data']['user'].nil?
        @error_message = "Помилка: користувач з логіном '#{input_user}' не існує."
        erb :error_page
      else
        @result = response
        erb :set
      end
    end
  end
end
