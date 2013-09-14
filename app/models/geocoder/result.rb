class Geocoder::Result
  SCORE_THRESHOLD = 80.0

  attr_accessor :geocoded_street_address, :geocoded_city_address, :geocoded_zip, :geocoded_coordinates, :score

  def attributes
    { :geocoded_street_address => nil_if_blank(@geocoded_street_address),
      :geocoded_city_address   => nil_if_blank(@geocoded_city_address),
      :geocoded_zip            => nil_if_blank(@geocoded_zip),
      :geocoded_coordinates    => nil_if_blank(@geocoded_coordinates)
    }
  end

  def good_enough?
    score and score >= SCORE_THRESHOLD
  end

  def nil_if_blank(value)
    if value.blank?
      nil
    else
      value
    end
  end
end
