module Geocoder
  class TestStub

    DEFAULT_ADDR_HASH = { :street=>"200 n spring st", :city=>"Los Angeles", :state=>"CA", :zipcode=>"90012" }
    ZIP_ONLY_HASH     = { :zipcode => "90012" }
    DISTANT_ZIP_HASH  = { :zipcode => "94121" }
    INVALID_HASH      = { :zipcode => 'aaaaa' }
    BAD_ADDRESS_HASH  = { :zipcode => '90012', :street => '200 N. Saothunoue', :city => "Langels", :state => "CA" }

    def self.geocoded_result_at(longitude, latitude, attributes = nil)
      result = Geocoder::Result.new
      result.geocoded_coordinates = Geocoder::Base.point_string(longitude,latitude)
      result.score = 95.0
      unless attributes.blank?
        attributes.each do |k,v|
          result.send(:"#{k}=",v)
        end
      end
      result
    end

    def self.geocode(addr_hash)
      @gr_default ||= geocoded_result_at('-118.24346689293799', '34.0538663528115',
                                         :geocoded_zip => '90012',
                                         :geocoded_street_address => '200 N. SPRING ST',
                                         :geocoded_city_address => 'LOS ANGELES, CA'
                                        )
      if addr_hash.blank? or addr_hash[:zipcode] == INVALID_HASH[:zipcode]
        @no_result ||= Geocoder::NoResult.new
      elsif addr_hash == BAD_ADDRESS_HASH # crappy address
        @bad_result ||= geocoded_result_at('-118.23878299501098', '34.0667712333786',
                                          :score => 20.0
                                         )
      elsif addr_hash == DEFAULT_ADDR_HASH # LA city hall
        @gr_default
      elsif addr_hash == ZIP_ONLY_HASH # 90012
        @gr_zip ||= geocoded_result_at('-118.23878299501098', '34.0667712333786',
                                       :geocoded_zip => '90012')
      elsif addr_hash[:zipcode] == DISTANT_ZIP_HASH[:zipcode] # 94121
        @gr_distant ||= geocoded_result_at('-122.49529653403','37.7773457639986',
                                           :geocoded_city_address => "San Francisco, CA",
                                           :geocoded_zip => '94121',
                                          )
      else
        Rails.logger.debug "Stub geocode method called with unknown hash: #{addr_hash.inspect}"
        @gr_default
      end
    end
  end
end
