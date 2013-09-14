require 'spec_helper'

describe RangeQuery, :type => :query do

  let :zip_code do
    90401
  end

  let! :closer_resource do
    FactoryGirl.create(:resource,
      :street_address_1 => "6815 Willoughby Ave.",
      :city => "Los Angeles",
      :state => "CA",
      :zip => "90038")
  end

  let! :farther_resource do
    FactoryGirl.create(:resource,
      :street_address_1 => "1040 N Wilson Ave.",
      :city => "Pasadena",
      :state => "CA",
      :zip => "91104")
  end

  describe "with_range_from" do

    it "should determine which is closer and farther" do
      range_query = RangeQuery.new(Resource)
      results = range_query.with_range_from(zip_code).order("range ASC")
      results.first.should == closer_resource
      results.last.should == farther_resource
    end

    it "should determine the distance in miles" do
      range_query = RangeQuery.new(Resource)
      results = range_query.with_range_from(zip_code).order("range ASC")
      results.first.range.to_f.should be > 9
      results.first.range.to_f.should be < 12
      results.last.range.to_f.should be > 21
      results.last.range.to_f.should be < 26
    end
  end
end