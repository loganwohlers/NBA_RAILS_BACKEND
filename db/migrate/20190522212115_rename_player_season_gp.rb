class RenamePlayerSeasonGp < ActiveRecord::Migration[5.2]
  def change
     rename_column :player_seasons, :games, :gp
  end
end
