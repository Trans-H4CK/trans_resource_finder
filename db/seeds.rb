# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

Resource.create(name: 'Chase Brexton Health Services', accessibility_rating: '4', trans_friendliness_rating: '5', service_quality_rating: '5', street_address_1: '1001 Cathedral Street', city: 'Baltimore', state: 'MD', zip: '21201')

Resource.create(name: 'Walt Whitman Clinic', accessibility_rating: '4', trans_friendliness_rating: '5', service_quality_rating: '3', street_address_1: '1701 14th St NW', city: 'Washington', state: 'DC', zip: '20009')

Resource.create(name: 'GLCCB', accessibility_rating: '3', trans_friendliness_rating: '3', service_quality_rating: '4', street_address_1: '241 W Chase Street', city: 'Baltimore', state: 'MD', zip: '21201')

Resource.create(name: 'Washington West Project', accessibility_rating: '4', trans_friendliness_rating: '5', service_quality_rating: '2', street_address_1: '1201 Locust Street', city: 'Philadelphia', state: 'PA', zip: '19107')

Resource.create(name: 'Mazzoni Center Family and Community Medicine', accessibility_rating: '4', trans_friendliness_rating: '5', service_quality_rating: '5', street_address_1: '809 Locust Street', city: 'Baltimore', state: 'MD', zip: '21201')

