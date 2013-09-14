module Geocoder
  class TAMUResponse < Base

      def initialize(xml_response)
        @doc = Nokogiri::XML.parse(xml_response)
        if unmatchable_result?
          @result = Geocoder::NoResult.new
        else
          @result = Geocoder::Result.new

          latitude  = get_value("//Latitude")
          longitude = get_value("//Longitude")
          @result.geocoded_coordinates    = self.class.point_string(longitude, latitude)
          @result.score                   = get_value("//MatchScore", :to_f)
          @result.geocoded_city_address   = extract_city_address
          @result.geocoded_street_address = extract_street_address
          @result.geocoded_zip            = extract_zip
        end
        @result
      end

      def result
        @result
      end

      def extract_zip
        zip = get_addr_part('Zip')
        zip = get_value('//ReferenceFeature/Zip') if zip.blank?
        zip
      end

      def unmatchable_result?
        type = get_value('//OutputGeocode/FeatureMatchingResultType')
        type and type == "Unmatchable"
      end

      def extract_street_address
        [ get_addr_part("Number"),
          get_addr_part('NumberFractional'),
          get_addr_part("PreDirectional"),
          get_addr_part("PreQualifier"),
          get_addr_part("PreType"),
          get_addr_part("PreName"),
          get_addr_part("Name").try(:titleize),
          get_addr_part("PostArticle"),
          get_addr_part("PostQualifier"),
          get_addr_part("Suffix"),
          get_addr_part("PostDirectional"),
          get_addr_part("SuiteType"),
          get_addr_part("SuiteNumber"),
          get_addr_part("PostOfficeBoxType"),
          get_addr_part("PostOfficeBoxNumber")
        ].compact.join(" ")
      end

      def extract_city_address
        city = get_addr_part('City')
      state = get_addr_part('State')
      if city
        "#{city}, #{state}"
      else
        state
      end
    end

    def get_addr_part(tag)
      get_value("//MatchedAddress/"+tag)
    end

    def get_value(xpath, conversion = nil)
      element =  @doc.xpath(xpath).first
      if element
        result = element.text
        result = nil if result.blank?
        if result && conversion
          result.try(conversion)
        else
          result
        end
      end
    end
  end
end
