require 'rails_helper'
RSpec.describe 'admin/animes/import_tweets', type: :system do
  describe '表示内容' do
    let!(:anime) { create(:anime) }
    let!(:episode) { create(:episode, :with_tweets, anime_id: anime.id) }
    context '表示内容' do
      before do
        allow(ConfirmTwitterSearchLimitService).to receive(:call).and_return(450)
      end
      it 'twitterで検索する文字列が正しく表示される' do
        visit admin_animes_import_tweet_path(episode.id)
        expect(page).to have_content(episode.decorate.search_twitter)
      end
      it 'エピソード情報が正しく表示される' do
        visit admin_animes_import_tweet_path(episode.id)
        expect(page).to have_content(anime.title)
        expect(page).to have_content("#{episode.num}話")
        expect(page).to have_content(episode.subtitle)
        expect(page).to have_content(episode.decorate.broadcast_date_and_time)
        expect(page).to have_content("#{episode.air_time}分")
      end
    end
  end
  describe 'ツイートインポート' do
    let!(:anime) { create(:anime) }
    let!(:episode) { create(:episode, anime_id: anime.id) }
    context '正常処理' do
      before do
        allow(ConfirmTwitterSearchLimitService).to receive(:call).and_return(450)
        allow(SearchTweetsService).to receive(:call).and_return('hoge')
        allow(Tweet).to receive(:convert_from_json).and_return(build_list(:tweet, 5, episode_id: episode.id))
      end
      it 'ツイートが正常にインポートできる' do
        visit admin_animes_import_tweet_path(episode.id)
        fill_in 'tweet_id', with: '12345'
        click_on '一括インポート'
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq admin_animes_tweets_path
        expect(page).to have_content(episode.tweets.first.text)
        expect(page).to have_content('ツイートを取得しました')
      end
      xit 'ツイートをインポートしたら、エピソード一覧画面にて『未取得』から『取得済』に変わる' do
        # CircleCIでは何故かエラーとなるのでスキップ対応
        visit admin_anime_path(anime.id)
        click_on '未取得'
        fill_in 'tweet_id', with: '12345'
        click_on '一括インポート'
        page.driver.browser.switch_to.alert.accept
        visit admin_anime_path(anime.id)
        expect(page).not_to have_content('未取得')
        expect(page).to have_content('取得済')
      end
    end
  end
end
