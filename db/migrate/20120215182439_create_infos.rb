class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :product_article
      t.text :content
      t.float :discount

      t.timestamps
    end
  end
end
