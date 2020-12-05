class CreateWordCount < ActiveRecord::Migration[5.0]
  def change
    create_table :word_counts do |t|
      t.references :user
      t.references :word
    end
  end
end 