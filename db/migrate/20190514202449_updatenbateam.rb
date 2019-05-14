class Updatenbateam < ActiveRecord::Migration[5.2]
 def change
    add_column :nba_teams, :nba_tricode, :string
  end
end
