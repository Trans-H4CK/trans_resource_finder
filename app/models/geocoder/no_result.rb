class Geocoder::NoResult

  def attributes
    { :geocoded_street_address => nil,
      :geocoded_city_address   => nil,
      :geocoded_zip            => nil,
      :geocoded_coordinates    => nil
    }
  end

  def good_enough?
    false
  end
end

