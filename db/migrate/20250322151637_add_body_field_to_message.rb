class AddBodyFieldToMessage < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :body, :string, null: false, limit: 255
  end
end
