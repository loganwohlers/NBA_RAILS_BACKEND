class CreateNbaGames < ActiveRecord::Migration[5.2]
  def change
    create_table :nba_games do |t|
      t.string :code

      t.timestamps
    end
  end
end
