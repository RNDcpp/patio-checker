class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table users do |t|
      # t.integer :hoge
    end
  end
end 