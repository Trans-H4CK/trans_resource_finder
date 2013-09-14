require 'spec_helper'

describe Resource do
  describe "model's" do
    describe "database table" do
      it { should have_db_column(:name) }
      it { should have_db_column(:street_address_1) }
      it { should have_db_column(:street_address_2) }
      it { should have_db_column(:city) }
      it { should have_db_column(:state) }
      it { should have_db_column(:zip) }
      it { should have_db_column(:phone) }
      it { should have_db_column(:website) }
      it { should have_db_column(:email) }
      it { should have_db_column(:contact_name) }
      it { should have_db_column(:services_offered) }
      it { should have_db_column(:people_served) }
      it { should have_db_column(:accessibility) }
      it { should have_db_column(:notes) }
      it { should have_db_column(:accessibility_rating) }
      it { should have_db_column(:trans_friendliness_rating) }
      it { should have_db_column(:service_quality_rating) }

      it { should have_db_column(:category_id) }
    end

    describe "associations" do
      it { should belong_to(:category) }
    end
  end


  describe "factory" do

  end
end
