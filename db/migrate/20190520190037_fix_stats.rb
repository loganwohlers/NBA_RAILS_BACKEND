class FixStats < ActiveRecord::Migration[5.2]
  def change
     change_column :player_seasons, :games, :string
     change_column :player_seasons, :fg2_per_g, :string
     change_column :player_seasons, :fg2a_per_g, :string
     change_column :player_seasons, :fg2_pct, :string
     change_column :player_seasons, :trb_per_g, :string
  end
end
