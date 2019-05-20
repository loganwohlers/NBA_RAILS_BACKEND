class RemoveOutFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :out, :boolean 
  end
end
