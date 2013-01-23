class AddMetaTags < ActiveRecord::Migration
  def up
    change_table :pages do |t|
      t.text :mtitle
      t.text :mdesc
      t.text :mkeywords
    end

    change_table :products do |t|
      t.text :mtitle
      t.text :mdesc
      t.text :mkeywords
    end
    
    change_table :categories do |t|
      t.text :mtitle
      t.text :mdesc
      t.text :mkeywords
    end
  end

  def down

    
  end
end
