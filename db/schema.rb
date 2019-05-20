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

ActiveRecord::Schema.define(version: 2019_05_20_190037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_lines", force: :cascade do |t|
    t.integer "player_season_id"
    t.string "mp"
    t.string "fg"
    t.string "fga"
    t.string "fg_pct"
    t.string "fg3"
    t.string "fg3a"
    t.string "fg3_pct"
    t.string "ft"
    t.string "fta"
    t.string "ft_pct"
    t.string "orb"
    t.string "drb"
    t.string "trb"
    t.string "ast"
    t.string "stl"
    t.string "blk"
    t.string "tov"
    t.string "pf"
    t.string "pts"
    t.string "plus_minus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "dnp"
    t.integer "game_id"
    t.index ["game_id"], name: "index_game_lines_on_game_id"
    t.index ["player_season_id"], name: "index_game_lines_on_player_season_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "code"
    t.string "date"
    t.string "start_time"
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.integer "home_pts"
    t.integer "away_pts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
    t.index ["season_id"], name: "index_games_on_season_id"
  end

  create_table "nba_players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_seasons", force: :cascade do |t|
    t.integer "player_id"
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
    t.integer "season_id"
    t.integer "team_id"
    t.string "games"
    t.string "fg2_per_g"
    t.string "fg2a_per_g"
    t.string "fg2_pct"
    t.string "trb_per_g"
    t.index ["player_id"], name: "index_player_seasons_on_player_id"
    t.index ["season_id"], name: "index_player_seasons_on_season_id"
    t.index ["team_id"], name: "index_player_seasons_on_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "year"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_seasons", force: :cascade do |t|
    t.integer "team_id"
    t.integer "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_team_seasons_on_season_id"
    t.index ["team_id"], name: "index_team_seasons_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nba_tricode"
  end

end
