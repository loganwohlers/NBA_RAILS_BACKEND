class CreateGameLines < ActiveRecord::Migration[5.2]
  def change
    create_table :game_lines do |t|
        t.integer :nba_season_id
        t.integer :player_season_id
        t.string :mp
        t.string :fg 
        t.string :fga
        t.string :fg_pct
        t.string :fg3
        t.string :fg3a
        t.string :fg3_pct
        t.string :ft
        t.string :fta
        t.string :ft_pct
        t.string :orb
        t.string :drb
        t.string :trb
        t.string :ast
        t.string :stl
        t.string :blk
        t.string :tov
        t.string :pf 
        t.string :pts
        t.string :plus_minus
      t.timestamps
    end
  end
end
