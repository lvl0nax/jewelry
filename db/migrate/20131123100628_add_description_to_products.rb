class AddDescriptionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :title, :string
    add_column :products, :description, :string
    add_column :products, :old_price, :float
    rename_column :products, :img, :for_main_page
    Product.update_all(for_main_page: false)
  end
end
