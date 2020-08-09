class AnimeTerm < ApplicationRecord
  belongs_to :anime
  belongs_to :term

  def self.set(animes, term)
    anime_terms = []
    animes.each do |anime|
      anime_terms << AnimeTerm.new(anime_id: anime.id, term_id: term.id)
    end
    AnimeTerm.import anime_terms, validate: true
  end
end
