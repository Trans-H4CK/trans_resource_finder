require 'nokogiri'
require 'typhoeus'
class Geocoder::TAMU < Geocoder::Base


  GEOCODER_URL = "https://geoservices.tamu.edu/Services/Geocode/WebService/GeocoderWebServiceHttpNonParsed_V02_96.aspx"

  class << self
    def geocode(addr_hash)
      if empty_request?(addr_hash)
        return Geocoder::NoResult.new
      end

      request = build_request(addr_hash)
      hydra = Typhoeus::Hydra.new
      Rails.logger.debug("Geocoding: " + addr_hash.inspect)
      hydra.queue(request)
      hydra.run
      response = request.response
      Geocoder::TAMUResponse.new(response.body).result
    end

    def build_request(addr_hash)
      request = Typhoeus::Request.new(GEOCODER_URL,
        :params => {
          :apiKey        => ENV["WEBGIS_API_KEY"],
          :version       => 2.96,
          :streetAddress => addr_hash[:street],
          :city          => addr_hash[:city],
          :state         => addr_hash[:state],
          :zip           => addr_hash[:zipcode],
          :verbose       => 'true',
          :format        => 'xml'
        }
      )
    end

    def empty_request?(addr_hash)
      addr_hash.blank? or addr_hash.values.all?{|v| v.blank?}
    end
  end
end
