class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :category_id
      t.decimal :min_price
      t.decimal :mas_price

      t.timestamps
    end
  end
end
