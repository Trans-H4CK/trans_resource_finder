class RangeQuery

  METERS_IN_A_MILE = 1609.344

  def initialize(relation)
    @relation = relation
  end

  def geocode(zip_code)
    Rails.application.config.geocoder.geocode(:zipcode => zip_code)
  end

  def with_range_from(zip_code)
    point = geocode(zip_code).geocoded_coordinates

    distance_in_meters = @relation.arel_table[:geocoded_coordinates].st_distance(point)

    distance_in_miles = Arel::Nodes::Division.new(distance_in_meters, METERS_IN_A_MILE)


    @relation.select(@relation.arel_table[Arel::star]).select(distance_in_miles.as("range"))

  end

end