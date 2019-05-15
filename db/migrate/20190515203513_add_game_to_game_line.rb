class AddGameToGameLine < ActiveRecord::Migration[5.2]
  def change
    add_column :game_lines, :nba_game_id, :integer
    remove_column :game_lines, :nba_season_id, :integer
  end
end
