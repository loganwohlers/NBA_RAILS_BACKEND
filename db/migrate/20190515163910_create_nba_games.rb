class CreateNbaGames < ActiveRecord::Migration[5.2]
  def change
    create_table :nba_games do |t|
      t.string :code
      t.string :date
      t.string :start_time
      t.references :nba_season
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :home_pts
      t.integer :away_pts

      t.timestamps
    end
  end
end
