class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :word_count_summary
    end
    add_index :users, :name
  end
end 