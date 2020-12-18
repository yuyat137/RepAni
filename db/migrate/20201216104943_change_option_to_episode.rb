class ChangeOptionToEpisode < ActiveRecord::Migration[6.0]
  def change
    change_column_null :episodes, :broadcast_datetime, false
    change_column :episodes, :public, :boolean, default: false
  end
end
