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

ActiveRecord::Schema.define(version: 20131211003907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: true do |t|
    t.string   "name"
    t.string   "yt_channel_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channels", ["user_id"], name: "index_channels_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "social_platform_totals", force: true do |t|
    t.integer  "num_views"
    t.string   "platform"
    t.integer  "video_id"
    t.date     "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "social_platform_totals", ["video_id"], name: "index_social_platform_totals_on_video_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "name"
    t.string   "refresh_token"
    t.string   "access_token"
    t.string   "expires"
  end

  create_table "users_videos", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.string   "signup_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_videos", ["user_id"], name: "index_users_videos_on_user_id", using: :btree
  add_index "users_videos", ["video_id"], name: "index_users_videos_on_video_id", using: :btree

  create_table "videos", force: true do |t|
    t.string   "title"
    t.string   "link"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_views"
    t.integer  "avg_view_duration"
    t.integer  "avg_view_pct"
    t.integer  "fb_views"
    t.integer  "twitter_views"
    t.string   "thumbnail"
    t.string   "video_id"
  end

  add_index "videos", ["video_id"], name: "index_videos_on_video_id", using: :btree

end
