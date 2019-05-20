class AddStatsToPlayerSeason < ActiveRecord::Migration[5.2]
  def change
     add_column :player_seasons, :games, :integer
     add_column :player_seasons, :fg2_per_g, :integer
     add_column :player_seasons, :fg2a_per_g, :integer
     add_column :player_seasons, :fg2_pct, :integer
     add_column :player_seasons, :trb_per_g, :integer
  end
end
