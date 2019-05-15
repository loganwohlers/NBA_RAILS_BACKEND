class Updatenbagame < ActiveRecord::Migration[5.2]
  def change
    add_column :nba_games, :time, :string
  end
end
