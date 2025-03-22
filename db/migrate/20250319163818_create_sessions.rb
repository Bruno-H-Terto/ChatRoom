class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.string :token, null: false
      t.datetime :expired_at, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
