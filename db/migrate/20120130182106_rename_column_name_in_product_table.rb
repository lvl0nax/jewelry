class RenameColumnNameInProductTable < ActiveRecord::Migration
  def change
  	rename_column :products, :title, :article
  end
end
