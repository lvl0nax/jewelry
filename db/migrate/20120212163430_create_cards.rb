class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|

      t.string :fio
      t.string :phone
      t.string :cardjson
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
