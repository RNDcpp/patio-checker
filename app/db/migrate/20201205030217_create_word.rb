class CreateWord < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string :surface
    end
    add_index :words, :surface
  end
end 