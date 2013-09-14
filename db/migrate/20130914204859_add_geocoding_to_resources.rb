class AddGeocodingToResources < ActiveRecord::Migration
  def change
    add_column :resources, :geocoded_street_address, :string
    add_column :resources, :geocoded_city_address, :string
    add_column :resources, :geocoded_zip, :string
    add_column :resources, :geocoded_coordinates, :point, :geographic => true
  end
end
