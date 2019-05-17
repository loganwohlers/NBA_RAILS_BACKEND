class AddTeamToPlayerSeasons < ActiveRecord::Migration[5.2]
  def change
     add_column :player_seasons, :team_id, :integer
  end
end
