class RenameActiveColumnToPublic < ActiveRecord::Migration[6.0]
  def change
    rename_column :episodes, :active, :public
  end
end
