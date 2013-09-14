module Geocoder
  class FakeTAMU
    FILENAME = File.join(Rails.root, 'spec', 'fixtures', 'stored_geocodes.yml')
    @stored_results = {}

    def self.geocode(addr_hash)
      result = @stored_results[addr_hash]
      if result.nil?
        #puts "Fetching geocode from TAMU Geoservices for "+addr_hash.inspect
        result = Geocoder::TAMU.geocode(addr_hash)
        @stored_results[addr_hash] = result
      end
      result
    end

    def self.preserve_stored_results
      File.open(FILENAME, "w") do |file|
        file.write @stored_results.to_yaml
      end
    end

    def self.load_stored_results
      if File.exists?(FILENAME)
        require 'yaml'
        @stored_results = YAML::load_file(FILENAME) or {}
      else
        @stored_results = {}
      end
    end
  end
end
