class ChangeNbaGame < ActiveRecord::Migration[5.2]
  def change
    remove_column :nba_games, :nba_season_id, :bigint
    add_column :nba_games, :nba_season_id, :integer
  end
end
