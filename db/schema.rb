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

ActiveRecord::Schema.define(version: 20140429025231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug"
    t.integer  "show_id"
    t.text     "show_notes"
    t.text     "transcript"
    t.datetime "published_at"
    t.string   "duration"
  end

  add_index "episodes", ["show_id"], name: "index_episodes_on_show_id", using: :btree

  create_table "hosts", force: true do |t|
    t.string "email"
    t.string "name"
    t.text   "bio"
    t.string "twitter_handle"
    t.string "facebook_handle"
    t.string "github_handle"
    t.string "slug"
    t.string "google_plus_handle"
  end

  create_table "picks", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "link"
    t.integer "host_id"
    t.integer "episode_id"
  end

  add_index "picks", ["episode_id"], name: "index_picks_on_episode_id", using: :btree
  add_index "picks", ["host_id"], name: "index_picks_on_host_id", using: :btree

  create_table "shows", force: true do |t|
    t.string "title"
    t.text   "description"
    t.string "twitter_link"
    t.string "facebook_link"
    t.string "google_link"
    t.string "rss_link"
    t.string "email"
    t.string "domain"
    t.string "slug"
    t.string "host_name"
    t.string "itunes_url"
  end

end
