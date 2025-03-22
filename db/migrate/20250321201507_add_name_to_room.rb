class AddNameToRoom < ActiveRecord::Migration[8.0]
  def change
    add_column :rooms, :name, :string, null: false
  end
end
