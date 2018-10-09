# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_07_222035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card_ids", array: true
    t.integer "user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "name_fr"
    t.string "name"
    t.integer "extension_set_id"
    t.integer "type"
    t.string "detailed_type"
    t.integer "rarity"
    t.text "text"
    t.integer "cmc"
    t.string "mana_cost"
    t.integer "color_ids", array: true
    t.string "image"
    t.integer "power"
    t.integer "defense"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "artist_name"
    t.integer "number_in_set"
    t.string "gatherer_link"
    t.integer "gatherer_id"
    t.string "name_clean"
    t.string "name_fr_clean"
    t.index ["name"], name: "index_cards_on_name"
    t.index ["name_fr"], name: "index_cards_on_name_fr"
  end

  create_table "colors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "decks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "colors", array: true
    t.integer "format_ids", array: true
    t.integer "user_id"
    t.integer "status", default: 1, null: false
  end

  create_table "extension_sets", force: :cascade do |t|
    t.string "name"
    t.datetime "release_date"
    t.string "set_visual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commun_logo"
    t.string "uncommun_logo"
    t.string "rare_logo"
    t.string "mythic_logo"
  end

  create_table "main_decks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deck_id"
    t.integer "card_ids", default: [], array: true
  end

  create_table "sideboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deck_id"
    t.integer "card_ids", default: [], array: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishlists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card_ids", array: true
    t.integer "user_id"
    t.string "string"
  end

end
