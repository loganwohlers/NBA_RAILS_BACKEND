class RenameGameLine < ActiveRecord::Migration[5.2]
  def change
    remove_column :game_lines, :nba_game_id, :integer
    add_column :game_lines, :game_id, :integer
  end
end
