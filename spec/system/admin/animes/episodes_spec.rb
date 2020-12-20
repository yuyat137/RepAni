require 'rails_helper'
RSpec.describe 'admin/animes/episodes', type: :system do
  describe 'エピソード一覧画面' do
    let!(:anime) { create(:anime) }
    let!(:episode_public) { create(:episode, anime_id: anime.id, public: true) }
    let!(:episode_private) { create(:episode, anime_id: anime.id, public: false) }
    let!(:episode_with_tweets) { create(:episode, :with_tweets, anime_id: anime.id) }
    let!(:episode_no_tweets) { create(:episode, anime_id: anime.id) }
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    context '表示値' do
      it 'エピソード情報が表示される' do
        visit admin_anime_path(anime)
        within("#episode_#{episode_public.id}") do
          expect(page).to have_content(episode_public.num)
          expect(page).to have_content(episode_public.subtitle)
          expect(page).to have_content(episode_public.air_time)
          expect(page).to have_content(episode_public.broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        end
      end
      it '表示されるエピソード数が正しい' do
        visit admin_anime_path(anime)
        trs = all('#episodes_list tr')
        expect(trs.length).to eq 4
      end
      it 'ツイート取得済の場合、取得済と表示される' do
        visit admin_anime_path(anime)
        within("#episode_#{episode_with_tweets.id}") do
          expect(page).to have_content('取得済')
        end
      end
      it 'ツイート未取得の場合、未取得と表示される' do
        visit admin_anime_path(anime)
        within("#episode_#{episode_no_tweets.id}") do
          expect(page).to have_content('未取得')
        end
      end
    end
    context '削除' do
      it 'エピソードを削除できる' do
        visit admin_anime_path(anime)
        within("#episode_#{episode_public.id}") do
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
        end
        sleep(1)
        trs = all('#episodes_list tr')
        expect(trs.length).to eq 3
        expect(page).not_to have_content(episode_public.subtitle)
      end
      it 'ツイートと共に削除される' do
        visit admin_anime_path(anime)
        within("#episode_#{episode_with_tweets.id}") do
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
        end
        sleep(1)
        expect(Tweet.all.length).to eq 0
        expect(page).not_to have_content('取得済')
      end
    end
    context 'ツイートリンクのページ遷移確認' do
      before { allow(ConfirmTwitterSearchLimitService).to receive(:call).and_return(450) }
      it 'ツイートがないエピソードはツイート取得画面に遷移する' do
        visit admin_anime_path(anime)
        within("#episode_#{episode_no_tweets.id}") do
          click_on '未取得'
        end
        expect(current_path).to eq new_admin_anime_episode_tweets_import_path(episode_no_tweets.id)
      end
      it 'ツイートがあるエピソードはツイート一覧画面に遷移する' do
        visit admin_anime_path(anime)
        within("#episode_#{episode_with_tweets.id}") do
          click_on '取得済'
        end
        expect(current_path).to eq admin_anime_episode_tweets_path(episode_with_tweets.id)
      end
    end
  end
  describe 'エピソード編集機能' do
    let!(:anime) { create(:anime) }
    let!(:anime_no_episode) { create(:anime) }
    let!(:episode_public) { create(:episode, anime_id: anime.id, public: true) }
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    context '正常処理' do
      it '登録済のエピソードを更新できること' do
        visit edit_admin_anime_episodes_path(anime)
        subtitle = Faker::Lorem.word
        fill_in 'anime_episodes_attributes_0_subtitle', with: subtitle
        select '非公開', from: 'anime_episodes_attributes_0_public'
        click_on '更新'
        within("#episode_#{episode_public.id}") do
          expect(page).to have_content(subtitle)
          expect(page).to have_content('false')
        end
      end
      it 'エピソードを追加して登録できること' do
        visit edit_admin_anime_episodes_path(anime)
        num = Episode.last.num + 1
        subtitle = Faker::Lorem.word
        broadcast_datetime = DateTime.now - 2.day
        air_time = Faker::Number.number(digits: 2)
        click_on '1行追加'
        (all('.episode-num')[1]).set(num)
        (all('.episode-subtitle')[1]).set(subtitle)
        (all('.episode-broadcast-datetime')[1]).set(broadcast_datetime)
        within all('.nested-fields')[1] do
          select '非公開'
        end
        click_on '更新'
        trs = all('#episodes_list tr')
        expect(trs[1]).to have_content(subtitle)
        expect(trs[1]).to have_content(broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        expect(trs[1]).to have_content('未取得')
        expect(trs[1]).to have_content('false')
        expect(trs.length).to eq 2
      end
      it '追加行にのみ削除ボタンがあること' do
        visit edit_admin_anime_episodes_path(anime)
        click_on '1行追加'
        trs = all('#episodes_tbody tr')
        expect(trs[0]).not_to have_link('削除')
        expect(trs[1]).to have_link('削除')
      end
    end
    context '特殊処理' do
      it '既に登録されてる話数は変更できないこと' do
        visit edit_admin_anime_episodes_path(anime)
        num = Episode.last.num + 1
        fill_in 'anime_episodes_attributes_0_num', with: num
        click_on '更新'
        trs = all('#episodes_list tr')
        expect(trs.length).to eq 1
        within(".episode-num") do
          expect(page).to have_content(episode_public.num)
        end
      end
      it '話数に重複がある場合更新処理は行わないこと' do
        visit edit_admin_anime_episodes_path(anime)
        click_on '1行追加'
        (all('.episode-num')[1]).set(episode_public.num)
        (all('.episode-broadcast-datetime')[1]).set(DateTime.now)
        (all('.episode-air-time')[1]).set(30)
        click_on '更新'
        expect(page).to have_content('更新に失敗しました')
        expect(page).to have_content('話数はすでに存在します')
      end
      it '新規追加行の話数が未入力の場合、エラーとなること' do
        visit edit_admin_anime_episodes_path(anime)
        click_on '1行追加'
        (all('.episode-num')[1]).set('')
        (all('.episode-broadcast-datetime')[1]).set(DateTime.now)
        (all('.episode-air-time')[1]).set(30)
        click_on '更新'
        expect(page).to have_content('更新に失敗しました')
        expect(page).to have_content('話数を入力してください')
      end
      it '新規追加行の時間が未入力の場合、エラーとなること' do
        visit edit_admin_anime_episodes_path(anime)
        click_on '1行追加'
        (all('.episode-num')[1]).set(Episode.last.num + 1)
        (all('.episode-broadcast-datetime')[1]).set(DateTime.now)
        (all('.episode-air-time')[1]).set('')
        click_on '更新'
        trs = all('#episodes_tbody tr')
        expect(page).to have_content('更新に失敗しました')
        expect(page).to have_content('時間を入力してください')
      end
      it '登録に失敗したとき、DBに未登録の行だけ削除ボタンがあること' do
        visit edit_admin_anime_episodes_path(anime)
        click_on '1行追加'
        click_on '更新'
        trs = all('#episodes_tbody tr')
        expect(trs[0]).to have_link('削除')
        expect(trs[1]).not_to have_link('削除')
        expect(trs[2]).not_to have_link('削除')
      end
      xit 'エピソードがない状態で更新すると' do
        visit edit_admin_anime_episodes_path(anime_no_episode)
        click_on '更新'
      end
    end
  end
end
