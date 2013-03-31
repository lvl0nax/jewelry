class AddFieldToProduct < ActiveRecord::Migration
  def change
    add_column :products, :img, :boolean, default: false
  end
end
