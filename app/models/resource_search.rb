
class ResourceSearch

  include Virtus
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :per_page, String, :default => "10"
  attribute :page, String
  attribute :zip_code, String
  attribute :category, String
  attribute :lat, String
  attribute :lon, String

  def persisted?
    false
  end

  def matches

    @scope = Resource

    match_categories

    query_distances

    # this one is last because otherwise it overrides the sort order
    paginate_results

    @scope

  end

  private

  def current_location
    if lat and lon
      point(lat, lon)
    elsif zip_code
      geocode(zip_code).geocoded_coordinates
    else
      nil
    end
  end

  def point(lat, lon)
    RGeo::Geographic.simple_mercator_factory.point(lat, lon)
  end

  def geocode(zip_code)
    Rails.application.config.geocoder.geocode(:zipcode => zip_code)
  end

  def match_categories
    if category
      category_model = Category.where(:name => category).first
      if category_model
        @scope = @scope.where(:category_id => category_model.id)
      end
    end
  end

  def query_distances
    if (current_location.present?)
      range_query = RangeQuery.new(@scope)
      @scope = range_query.with_range_from(current_location)
      @scope = @scope.order('range ASC')
    else
      @scope = @scope.order('name ASC')
    end
  end

  def paginate_results
    @scope = @scope.paginate(:page => page, :per_page => per_page.to_i)
  end

end
