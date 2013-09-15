class RangeQuery

  METERS_IN_A_MILE = 1609.344

  def initialize(relation)
    @relation = relation
  end

  def with_range_from(point)

    distance_in_meters = @relation.arel_table[:geocoded_coordinates].st_distance(point)

    distance_in_miles = Arel::Nodes::Division.new(distance_in_meters, METERS_IN_A_MILE)


    @relation.select(@relation.arel_table[Arel::star]).select(distance_in_miles.as("range"))

  end

end