class AddToPlayerSeasons < ActiveRecord::Migration[5.2]
  def change
     add_column :player_seasons, :team_season_id, :integer
  end
end
