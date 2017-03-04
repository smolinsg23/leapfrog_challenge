require 'rest_client'
require "json"

module LeapfrogChallenge
  class Client
    attr_reader :url
    BASE_URL = "http://not_real.com/customer_scoring"

    def initialize(url = BASE_URL)
      @url = url
    end

    def make_request(income, zipcode, age)
      response = RestClient.get(BASE_URL, params: { income: income, zipcode: zipcode, age: age })
      if response.code == 200
        attributes = JSON.parse(response, symbolize_names: true)
        Score.new_from_request(attributes)
      end
    rescue RestClient::BadRequest
      {
        status: 400,
        error: "Bad request"
      }
    rescue RestClient::InternalServerError
      {
        status: 500,
        error: "Internal server error"
      }
    rescue RestClient::RequestTimeout
      { error: "Server timeout" }
    end
  end
end
