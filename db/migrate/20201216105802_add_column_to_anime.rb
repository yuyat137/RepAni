class AddColumnToAnime < ActiveRecord::Migration[6.0]
  def change
    add_column :animes, :first_broadcast_datetime, :datetime
  end
end
