# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160302011123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "platforms", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlist_songs", force: :cascade do |t|
    t.integer  "playlist_id"
    t.integer  "song_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "playlist_songs", ["playlist_id"], name: "index_playlist_songs_on_playlist_id", using: :btree
  add_index "playlist_songs", ["song_id"], name: "index_playlist_songs_on_song_id", using: :btree

  create_table "playlists", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.hstore   "preferences"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "playlists", ["user_id"], name: "index_playlists_on_user_id", using: :btree

  create_table "songs", force: :cascade do |t|
    t.string   "track_id"
    t.string   "title"
    t.string   "artist"
    t.string   "album"
    t.string   "image"
    t.integer  "platform_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "songs", ["platform_id"], name: "index_songs_on_platform_id", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.string   "key"
    t.string   "secret_key"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "platform_id"
  end

  add_index "tokens", ["platform_id"], name: "index_tokens_on_platform_id", using: :btree
  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "name"
    t.string   "image"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "playlist_songs", "playlists"
  add_foreign_key "playlist_songs", "songs"
  add_foreign_key "playlists", "users"
  add_foreign_key "songs", "platforms"
  add_foreign_key "tokens", "platforms"
  add_foreign_key "tokens", "users"
end
