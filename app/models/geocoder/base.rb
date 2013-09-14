module Geocoder
  class Base

    def self.geometry_factory
      @factory ||= RGeo::Geographic.spherical_factory
    end

    def self.point(coords)
      RGeo::WKRep::WKTParser.new(self.geometry_factory, :support_ewkt => true).parse(coords)
    end

    def self.point_string(longitude, latitude)
      "POINT(#{longitude} #{latitude})"
    end
  end
end

