class ChangeSeasons < ActiveRecord::Migration[5.2]
  def change
    rename_table :nba_seasons, :seasons
  end
end
