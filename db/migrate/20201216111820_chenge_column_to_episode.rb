class ChengeColumnToEpisode < ActiveRecord::Migration[6.0]
  def change
    change_column_null :episodes, :public, false
  end
end
