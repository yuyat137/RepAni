class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.bigint :tweet_id
      t.string :name
      t.string :screen_name
      t.text :text
      t.string :image_url1
      t.string :image_url2
      t.string :image_url3
      t.string :image_url4
      t.datetime :tweeted_at
      t.timestamps
    end
  end
end
