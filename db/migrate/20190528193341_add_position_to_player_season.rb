class AddPositionToPlayerSeason < ActiveRecord::Migration[5.2]
  def change
     add_column :player_seasons, :position, :string
  end
end
