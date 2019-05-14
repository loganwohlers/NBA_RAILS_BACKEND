class CreateNbaSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :nba_seasons do |t|
      t.integer :year
      t.string :description

      t.timestamps
    end
  end
end
