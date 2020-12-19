class AddColumnRoleToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :integer, null: false, deafult: 0
  end
end
