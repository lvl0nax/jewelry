class CreateDopinfos < ActiveRecord::Migration
  def change
    create_table :dopinfos do |t|
      t.string :title
      t.string :tag

      t.timestamps
    end
  end
end
