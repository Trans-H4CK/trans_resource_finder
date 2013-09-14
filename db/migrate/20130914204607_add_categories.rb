class AddCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :internal_name
    end

    add_column :resources, :category_id, :integer
    add_index :resources, :category_id
  end
end
