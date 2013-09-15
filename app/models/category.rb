class Category < ActiveRecord::Base
  has_many :resources

  attr_accessible :name,
                  :internal_name

end