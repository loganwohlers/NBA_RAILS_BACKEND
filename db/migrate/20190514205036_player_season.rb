class PlayerSeason < ActiveRecord::Migration[5.2]
  def change
    create_table :player_seasons do |t|
      t.integer :player_id
      t.integer :season_id
    end
  end
end
