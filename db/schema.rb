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

ActiveRecord::Schema.define(version: 2019_05_14_220740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nba_games", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time"
  end

  create_table "nba_players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nba_seasons", force: :cascade do |t|
    t.integer "year"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nba_teams", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nba_tricode"
  end

  create_table "player_seasons", force: :cascade do |t|
    t.integer "player_id"
    t.integer "season_id"
    t.string "age"
    t.string "mp_per_g"
    t.string "fg_per_g"
    t.string "fga_per_g"
    t.string "fg_pct"
    t.string "fg3_per_g"
    t.string "fg3a_per_g"
    t.string "fg3_pct"
    t.string "efg_pct"
    t.string "ft_per_g"
    t.string "fta_per_g"
    t.string "ft_pct"
    t.string "orb_per_g"
    t.string "drb_per_g"
    t.string "ast_per_g"
    t.string "stl_per_g"
    t.string "blk_per_g"
    t.string "tov_per_g"
    t.string "pf_per_g"
    t.string "pts_per_g"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.string "position"
    t.boolean "out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
