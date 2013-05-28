class AddFieldsAndIndexToCards < ActiveRecord::Migration
  def change
    add_column :cards, :products, :text
    add_column :cards, :cost, :float

    add_index :products, :article
  end
end
