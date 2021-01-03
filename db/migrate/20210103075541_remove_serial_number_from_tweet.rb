class RemoveSerialNumberFromTweet < ActiveRecord::Migration[6.0]
  def change
    remove_column :tweets, :serial_number
  end
end
