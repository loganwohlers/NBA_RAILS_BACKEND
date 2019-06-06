class Remove < ActiveRecord::Migration[5.2]
  def change
     remove_column :player_seasons, :team_id, :integer 
     remove_column :player_seasons, :season_id, :integer 
  end
end
