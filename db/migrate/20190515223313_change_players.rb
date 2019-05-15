class ChangePlayers < ActiveRecord::Migration[5.2]
   def change
    remove_column :players, :nba_team_id, :integer
    add_column :players, :team_id, :integer
  end
end
