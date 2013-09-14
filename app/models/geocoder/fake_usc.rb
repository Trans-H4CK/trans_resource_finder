module Geocoder
  class FakeUSC
    FILENAME = File.join(Rails.root, 'spec', 'fixtures', 'stored_geocodes.yml')
    @stored_results = {}
    def initialize(find_missing=false)
      @find_missing = find_missing
    end

    def self.geocode(addr_hash)
      if empty_request?(addr_hash)
        return Geocoder::NoResult.new
      end
      result = @stored_results[addr_hash]
      if result.nil? and @find_missing
        puts "Fetching geocode from USC Webgis for "+addr_hash.inspect
        result = Geocoder::USC.geocode(addr_hash)
        @stored_results[addr_hash] = result
      end
      result
    end

    def self.preserve_stored_results
      if @find_missing
        File.open(FILENAME, "w") do |file|
          file.write @stored_results.to_yaml
        end
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
    def self.empty_request?(addr_hash)
      addr_hash.blank? or addr_hash.values.all?{|v| v.blank?}
    end
  end
end
