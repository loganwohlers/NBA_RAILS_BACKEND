class AddForeignIndeces < ActiveRecord::Migration[5.2]
  def change
    add_index :player_seasons, :team_id
    add_index :player_seasons, :season_id
    add_index :player_seasons, :player_id
    add_index :game_lines, :game_id
    add_index :game_lines, :player_season_id
    add_index :games, :season_id
    add_index :team_seasons, :season_id
    add_index :team_seasons, :team_id

  end
end
