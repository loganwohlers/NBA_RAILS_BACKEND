class ChangeGames < ActiveRecord::Migration[5.2]
  def change
    rename_table :nba_games, :games
  end
end
