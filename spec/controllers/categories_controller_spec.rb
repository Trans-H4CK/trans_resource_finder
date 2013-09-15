require 'spec_helper'

describe Api::V1::CategoriesController do
  let! :category_1 do
    FactoryGirl.create(:category, :name => "Category 1")
  end

  let! :category_2 do
    FactoryGirl.create(:category, :name => "Category 2")
  end

  describe "GET index" do
    it "should return all results by default" do
      get :index
      assigns[:categories].should have(2).categories
    end
  end

end