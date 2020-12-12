class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :document_count, default: 0
    end
    add_index :users, :name
  end
end 