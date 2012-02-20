class ChangeColumnFromCardTable < ActiveRecord::Migration
  def change
    change_column(:cards, :cardjson, :text)
  end
end
