require 'httparty'

module Stockfighter
  class Request
    include HTTParty
    base_uri 'api.stockfighter.io'
    headers 'X-Starfighter-Authorization' => Stockfighter::APIKey

    class BadRequest < RuntimeError
    end

    class JSONOnly < HTTParty::Parser
      def parse
        json
      end
    end

    parser JSONOnly

    def self.venue_exists?(venue)
      response = get "/ob/api/venues/#{venue}/heartbeat"
      response.code == 200 ? true : false
    end

    def self.stock_list(venue)
      response = get "/ob/api/venues/#{venue}/stocks"
      raise BadRequest.new(response["error"]) if response.code != 200
      response.parsed_response["symbols"]
    end
  end  
end