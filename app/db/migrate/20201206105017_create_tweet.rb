class CreateTweet < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.references :user
      t.text :text
      t.boolean :counted, default: false
      t.datetime :posted_at, null: false
    end
    add_index :tweets, [:user_id, :posted_at], unique: true
    add_index :tweets, :counted
  end
end 