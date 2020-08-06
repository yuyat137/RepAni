namespace :anime_api do
  desc 'APIからアニメを取得し、DBに登録されてないアニメを保存'
  task get_anime: :environment do
    Anime.import_by_api
  end
end
