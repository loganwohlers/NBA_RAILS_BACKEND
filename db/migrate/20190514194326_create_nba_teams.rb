class CreateNbaTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :nba_teams do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
