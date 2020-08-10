class AnimeTerm < ApplicationRecord
  belongs_to :anime
  belongs_to :term
  validates :anime_id, presence: true, uniqueness: { scope: :term_id, case_sensitive: false }
  validates :term_id, presence: true
end
