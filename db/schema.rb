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

ActiveRecord::Schema.define(version: 2020_08_14_052242) do

  create_table "anime_terms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "anime_id", null: false
    t.bigint "term_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["anime_id", "term_id"], name: "index_anime_terms_on_anime_id_and_term_id", unique: true
    t.index ["anime_id"], name: "index_anime_terms_on_anime_id"
    t.index ["term_id"], name: "index_anime_terms_on_term_id"
  end

  create_table "animes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "broadcast_datetime"
    t.integer "air_time"
    t.string "public_url"
    t.string "twitter_account"
    t.string "twitter_hash_tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_animes_on_title", unique: true
  end

  create_table "terms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "anime_id"
    t.integer "year", null: false
    t.integer "season", null: false
    t.string "season_ja", null: false
    t.boolean "now", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["anime_id"], name: "index_terms_on_anime_id"
    t.index ["year", "season"], name: "index_terms_on_year_and_season", unique: true
  end

  create_table "tweets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "tweet_id"
    t.string "name"
    t.string "screen_name"
    t.text "text"
    t.string "image_url1"
    t.string "image_url2"
    t.string "image_url3"
    t.string "image_url4"
    t.datetime "tweeted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
