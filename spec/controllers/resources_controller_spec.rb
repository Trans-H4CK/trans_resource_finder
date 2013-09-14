require 'spec_helper'

describe Api::V1::ResourcesController do
  let! :category_1 do
    FactoryGirl.create(:category, :name => "Category 1")
  end

  let! :category_2 do
    FactoryGirl.create(:category, :name => "Category 2")
  end

  let! :resource_1 do
    resource = FactoryGirl.create(:resource)
    resource.category = category_1
    resource.save
    resource
  end

  let! :resource_2 do
    resource = FactoryGirl.create(:resource)
    resource.category = category_2
    resource.save
    resource
  end

  describe "GET index" do
    it "should return all results by default" do
      get :index
      assigns[:resources].should == Resource.all
    end

    it "should return only results for category when category is passed" do
      get :index, {:category => "Category 1"}
      assigns[:resources].should include(resource_1)
      assigns[:resources].should_not include(resource_2)
    end
  end
end