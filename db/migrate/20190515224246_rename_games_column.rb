class RenameGamesColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :nba_season_id, :integer
    add_column :games, :season_id, :integer
  end
end
