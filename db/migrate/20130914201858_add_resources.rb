class AddResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string  :name
      t.string  :street_address_1
      t.string  :street_address_2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :phone                , :default => ""
      t.string  :website              , :default => ""
      t.string  :email                , :default => ""
      t.string  :contact_name         , :default => ""
      t.text    :services_offered     , :default => ""
      t.text    :people_served        , :default => ""
      t.text    :accessibility        , :default => ""
      t.text    :notes                , :default => ""
      t.integer :accessibility_rating
      t.integer :trans_friendliness_rating
      t.integer :service_quality_rating

      t.timestamps
    end
  end
end
