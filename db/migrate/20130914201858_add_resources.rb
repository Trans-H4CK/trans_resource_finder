class AddResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string  :name
      t.string  :street_address_1
      t.string  :street_address_2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :phone
      t.string  :website
      t.string  :email
      t.string  :contact_name
      t.text    :services_offered
      t.text    :people_served
      t.text    :accessibility
      t.text    :notes
      t.integer :accessibility_rating
      t.integer :trans_friendliness_rating
      t.integer :service_quality_rating

      t.timestamps
    end
  end
end
