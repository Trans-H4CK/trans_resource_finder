FactoryGirl.define do
  factory :resource do
    name "Shelter 1"
    street_address_1 "123 Fake St."
    street_address_2 ""
    city "Los Angeles"
    state "CA"
    zip "90029"
    sequence :phone do |n| "123-456-789#{n}" end
  end

end