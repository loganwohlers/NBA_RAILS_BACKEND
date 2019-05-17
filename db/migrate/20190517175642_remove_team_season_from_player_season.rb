class RemoveTeamSeasonFromPlayerSeason < ActiveRecord::Migration[5.2]
  
  def change
    remove_column :player_seasons, :team_season_id, :integer
    add_column :player_seasons, :season_id, :integer
  end
end