class AddToGamelines < ActiveRecord::Migration[5.2]
  def change
    add_column :game_lines, :dnp, :boolean
  end
end
