module Geocodable

  def geocode_address
    if address_changed?
      result = geocode_full_address
      assign_attributes(result.attributes, :as => :geocoder)
    end
  end

  def address_changed?
    street_address_1_changed? or state_changed? or city_changed? or zip_changed?
  end

  def geocode_full_address
    Rails.application.config.geocoder.geocode(:street => self.street_address_1, :city => self.city, :state => self.state, :zipcode => self.zip)
  end
end
