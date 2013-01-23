class AddSomeColumns < ActiveRecord::Migration
  def up

    change_table :cards do |t| 
      # Add following columns to card table
      t.string :email
      t.string :city
      t.string :address
      t.boolean :has_courier, :default => false 
      t.text :comment

      
    end
  end

  def down
  end
end
