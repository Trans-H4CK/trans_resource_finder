require 'spec_helper'

describe Resource do

  describe "geocoding" do

    #let! :reference_full_address do
      #Geocoder::Tiger.geocode(:street => "200 N. Spring St.", :city => "Los Angeles", :state => "CA", :zipcode => "90012")
    #end
    #let! :reference_zipcode do
      #Geocoder::Tiger.geocode(:zipcode => "90012")
    #end

    let! :full_address_point do
      # these are the coordinates of Los Angeles City Hall,
      # 200 N. Spring St., Los Angeles, CA 90012
      Geocoder::Base.point(Geocoder::Base.point_string('-118.24346689293799', '34.0538663528115'))
    end

    let! :zip_only_point do
      # these are the coordinates of the center of zipcode 90012
      Geocoder::Base.point(Geocoder::Base.point_string('-118.23878299501098', '34.0667712333786'))
    end

    describe "When the user enters a full address" do
      let! :resource do
        FactoryGirl.create(:resource,
          :zip => '90012',
          :street_address_1 => '200 N. Spring St.',
          :city => "Los Angeles",
          :state => "CA"
        )
      end

      it "should geocode the address correctly" do
        resource.geocoded_coordinates.should be_within_geographic(200).of(full_address_point)
      end

      it "should set the geocoded_zip" do
        resource.reload.geocoded_zip.should == '90012'
      end
    end


    describe "When the user enters a misspelled address" do
      let! :resource do
        FactoryGirl.create(:resource,
          :zip => '90012',
          :street_address_1 => '200 N. Spring St.',
          :city => "Los Angeles",
          :state => "CA"
        )
      end

      it "should geocode the address correctly" do
        resource.geocoded_coordinates.should be_within_geographic(200).of(full_address_point)
      end
    end

    describe "When the user enters a very poor address" do
      let! :resource do
        FactoryGirl.create(:resource,
          :zip => '90012',
          :street_address_1 => '200 N. Saothunoue',
          :city => "Langels",
          :state => "CA"
        )
      end

      it "should geocode just the zipcode" do
        resource.geocoded_coordinates.should be_within_geographic(200).of(zip_only_point)
      end
    end

  end
end