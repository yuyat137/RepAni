class CreateAnimeTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :anime_terms do |t|
      t.belongs_to :anime
      t.belongs_to :term
      t.timestamps
    end
  end
end
