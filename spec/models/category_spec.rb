require 'spec_helper'

describe Category do
  describe "model's" do
    describe "database table" do
      it { should have_db_column(:name) }
      it { should have_db_column(:internal_name) }
    end

    describe "associations" do
      it { should have_many(:resources) }
    end
  end


  describe "factory" do

  end
end
