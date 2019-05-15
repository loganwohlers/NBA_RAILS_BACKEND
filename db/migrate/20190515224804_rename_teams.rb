class RenameTeams < ActiveRecord::Migration[5.2]
def change
    rename_table :nba_teams, :teams
  end
end
