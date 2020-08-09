class CreateTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :terms do |t|
      t.belongs_to :anime
      t.integer :year, null: false
      t.integer :season, null: false
      t.string :season_ja, null: false
      t.timestamps
    end

    add_index :terms, [:year, :season], unique: true
  end
end
