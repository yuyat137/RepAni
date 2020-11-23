term = Term.seed(:id, {
  year: 2020,
  season: 3,
  season_ja: '夏'
}).first

AnimeTerm.seed(:id, {
  anime_id: Anime.find_by(title: 'テストアニメ').id,
  term_id: term.id
})

