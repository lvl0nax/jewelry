class ChangeColumnNameForProductsTable < ActiveRecord::Migration
  def up
    remove_column :products, :count
    add_column :products, :number, :integer
  end

  def down
    remove_column :products, :number
    add_column :products, :count, :integer
  end
end
