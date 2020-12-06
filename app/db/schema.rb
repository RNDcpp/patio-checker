# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_06_105017) do

  create_table "tweets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "user_id"
    t.text "text"
    t.boolean "counted", default: false
    t.datetime "posted_at", null: false
    t.index ["counted"], name: "index_tweets_on_counted"
    t.index ["user_id", "posted_at"], name: "index_tweets_on_user_id_and_posted_at", unique: true
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.integer "document_count"
    t.index ["name"], name: "index_users_on_name"
  end

  create_table "word_counts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "user_id"
    t.integer "word_id"
    t.integer "count", default: 0
    t.index ["user_id"], name: "index_word_counts_on_user_id"
    t.index ["word_id"], name: "index_word_counts_on_word_id"
  end

  create_table "words", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "surface"
    t.string "feature"
    t.index ["surface", "feature"], name: "index_words_on_surface_and_feature"
  end

end
