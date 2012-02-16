class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.integer :count
      t.string :brand
      t.integer :category_id

      t.timestamps
    end
  end
end
