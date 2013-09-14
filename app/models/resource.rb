class Resource < ActiveRecord::Base
  include Geocodable

  set_rgeo_factory_for_column(:geocoded_coordinates, RGeo::Geographic.simple_mercator_factory)

  belongs_to :category

  before_validation :geocode_address

  validates_presence_of :name, :street_address_1, :city, :state, :zip

  attr_accessible :name, :street_address_1, :street_address_2, :city, :state, :zip, :phone

  attr_accessible :accessibility_rating,
                  :trans_friendliness_rating,
                  :service_quality_rating,
                  :website,
                  :email,
                  :contact_name,
                  :services_offered,
                  :people_served,
                  :accessibility,
                  :notes

  attr_accessible :geocoded_street_address, :geocoded_city_address, :geocoded_coordinates, :geocoded_zip, :as => :geocoder
end