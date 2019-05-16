class CreateTeamSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :team_seasons do |t|
      t.integer :team_id
      t.integer :season_id
      t.timestamps
    end
  end
end
