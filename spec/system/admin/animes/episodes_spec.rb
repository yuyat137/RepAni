require 'rails_helper'
RSpec.describe 'admin/animes/episodes', type: :system do
  describe 'エピソード一覧機能(アニメ詳細機能内)' do
    let!(:anime) { create(:anime) }
    let!(:episode1) { create(:episode, anime_id: anime.id, public: true) }
    let!(:episode2) { create(:episode, anime_id: anime.id, public: false) }
    context '表示値確認' do
      it '表示値が正しい' do
        create(:tweet, episode_id: episode2.id)
        visit admin_anime_path(anime)
        trs = all('#episode-detail tbody tr')
        expect(trs[0].text.split[0]).to have_content(episode1.num)
        expect(trs[0]).to have_content(episode1.subtitle)
        expect(trs[0]).to have_content(episode1.broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        expect(trs[0].text.split[4]).to have_content(episode1.air_time)
        expect(trs[0]).to have_content('true')
        expect(trs[0]).to have_content('未取得')
        expect(trs[0]).to have_link('削除')
        expect(trs[1].text.split[0]).to have_content(episode2.num)
        expect(trs[1]).to have_content(episode2.subtitle)
        expect(trs[1]).to have_content(episode2.broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        expect(trs[1].text.split[4]).to have_content(episode2.air_time)
        expect(trs[1]).to have_content('false')
        expect(trs[1]).to have_content('取得済')
        expect(trs[1]).to have_link('削除')
        expect(trs.length).to eq 2
      end
    end
    context '削除確認' do
      it 'ツイートと共に削除される' do
        create(:tweet, episode_id: episode2.id)
        visit admin_anime_path(anime)
        expect(Tweet.all.length).to eq 1
        within all('#episode-detail tbody tr')[1] do
          page.accept_confirm do
            click_on '削除'
          end
        end
        expect(current_path).to eq admin_anime_path(anime)
        trs = all('#episode-detail tbody tr')
        expect(trs[0].text.split[0]).to have_content(episode1.num)
        expect(trs[0]).to have_content(episode1.subtitle)
        expect(trs[0]).to have_content(episode1.broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        expect(trs[0].text.split[4]).to have_content(episode1.air_time)
        expect(trs[0]).to have_content('未取得')
        expect(trs[0]).to have_content('true')
        expect(trs[0]).to have_link('削除')
        expect(trs.length).to eq 1
        expect(Tweet.all.length).to eq 0
      end
    end
    context 'ページ遷移確認' do
      before do
        allow(ConfirmTwitterSearchLimitService).to receive(:call).and_return(450)
      end
      it 'ツイートがないエピソードはツイート取得画面に遷移する' do
        visit admin_anime_path(anime)
        within all('#episode-detail tbody tr')[0] do
          click_on '未取得'
        end
        expect(current_path).to eq new_admin_animes_tweets_import_path
      end
      it 'ツイートがあるエピソードはツイート一覧画面に遷移する' do
        create(:tweet, episode_id: episode1.id)
        visit admin_anime_path(anime)
        within all('#episode-detail tbody tr')[0] do
          click_on '取得済'
        end
        expect(current_path).to eq admin_animes_tweets_path
      end
    end
  end
  describe 'エピソード編集機能(アニメ詳細機能内)' do
    let!(:anime) { create(:anime) }
    let!(:episode1) { create(:episode, anime_id: anime.id, num: 1, public: true) }
    let!(:episode2) { create(:episode, anime_id: anime.id, num: 2, public: false) }
    context '正常処理' do
      it '登録済のエピソードを更新できること' do
        visit edit_admin_animes_episode_path(anime)
        subtitle = 'サブタイトル更新'
        broadcast_datetime = DateTime.now - 1.day
        air_time = 55
        fill_in 'anime_episodes_attributes_0_subtitle', with: subtitle
        fill_in 'anime_episodes_attributes_0_broadcast_datetime', with: broadcast_datetime
        fill_in 'anime_episodes_attributes_0_air_time', with: air_time
        select '非公開', from: 'anime_episodes_attributes_0_public'
        click_on '更新'
        trs = all('#episode-detail tbody tr')
        expect(trs[0].text.split[0]).to have_content(episode1.num)
        expect(trs[0]).to have_content(subtitle)
        expect(trs[0]).to have_content(broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        expect(trs[0].text.split[4]).to have_content(air_time)
        expect(trs[0]).to have_content('未取得')
        expect(trs[0]).to have_content('false')
        expect(trs.length).to eq 2
      end
      it 'エピソードを追加して登録できること' do
        visit edit_admin_animes_episode_path(anime)
        click_on '1行追加'
        num = 3
        subtitle = 'サブタイトル追加'
        broadcast_datetime = DateTime.now - 2.day
        air_time = 15
        (all('.episode-num')[2]).set(num)
        (all('.episode-subtitle')[2]).set(subtitle)
        (all('.episode-air-time')[2]).set(air_time)
        within all('.nested-fields')[2] do
          find('.episode-broadcast-datetime').set(broadcast_datetime)
          select '非公開'
        end
        click_on '更新'
        trs = all('#episode-detail tbody tr')
        expect(trs[2].text.split[0]).to have_content(num)
        expect(trs[2]).to have_content(subtitle)
        expect(trs[2]).to have_content(broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        expect(trs[2].text.split[4]).to have_content(air_time)
        expect(trs[2]).to have_content('未取得')
        expect(trs[2]).to have_content('false')
        expect(trs.length).to eq 3
      end
      it '話数と時間だけ入力すれば追加登録できること' do
        visit edit_admin_animes_episode_path(anime)
        click_on '1行追加'
        num = 3
        air_time = 15
        (all('.episode-num')[2]).set(num)
        (all('.episode-air-time')[2]).set(air_time)
        click_on '更新'
        trs = all('#episode-detail tbody tr')
        expect(trs[2].text.split[0]).to have_content(num)
        expect(trs.length).to eq 3
      end
    end
    context '特殊処理' do
      it '既に登録されてる話数は変更できないこと' do
        visit edit_admin_animes_episode_path(anime)
        num = 5
        fill_in 'anime_episodes_attributes_0_num', with: num
        click_on '更新'
        trs = all('#episode-detail tbody tr')
        expect(trs[0].text.split[0]).to have_content(episode1.num)
        expect(trs[0].text.split[0]).not_to have_content(num)
        expect(trs.length).to eq 2
      end
      it '話数に重複がある場合更新処理は行わないこと' do
        visit edit_admin_animes_episode_path(anime)
        click_on '1行追加'
        subtitle = 'サブタイトル更新'
        # 2行目(話数の重複と関係のない行も更新されないことの確認)
        fill_in 'anime_episodes_attributes_1_subtitle', with: subtitle
        # 3行目(1行目と話数が被る行)
        (all('.episode-num')[2]).set(1)
        (all('.episode-air-time')[2]).set(20)
        click_on '更新'
        expect(page).to have_content('更新に失敗しました')
        expect(anime.episodes.length).to eq 2
      end
      it '新規追加行の話数が未入力の場合、その行は登録されないこと' do
        visit edit_admin_animes_episode_path(anime)
        click_on '1行追加'
        subtitle = 'サブタイトル追加'
        air_time = 45
        (all('.episode-subtitle')[2]).set(subtitle)
        (all('.episode-air-time')[2]).set(air_time)
        click_on '更新'
        trs = all('#episode-detail tbody tr')
        expect(trs.length).to eq 2
        expect(trs[0]).not_to have_content(subtitle)
        expect(trs[1]).not_to have_content(subtitle)
      end
      it '新規追加行の時間が未入力の場合、その行は登録されないこと' do
        visit edit_admin_animes_episode_path(anime)
        click_on '1行追加'
        num = 3
        subtitle = 'サブタイトル追加'
        (all('.episode-num')[2]).set(num)
        (all('.episode-subtitle')[2]).set(subtitle)
        (all('.episode-air-time')[2]).set('')
        click_on '更新'
        trs = all('#episode-detail tbody tr')
        expect(trs.length).to eq 2
        expect(trs[0]).not_to have_content(subtitle)
        expect(trs[1]).not_to have_content(subtitle)
      end
      it '登録済の行の時間が未入力の場合、その行は更新されないこと' do
        visit edit_admin_animes_episode_path(anime)
        subtitle = 'サブタイトル更新'
        fill_in 'anime_episodes_attributes_0_subtitle', with: subtitle
        fill_in 'anime_episodes_attributes_0_air_time', with: ''
        click_on '更新'
        trs = all('#episode-detail tbody tr')
        expect(trs.length).to eq 2
        expect(trs[0]).not_to have_content(subtitle)
        expect(trs[0]).to have_content(episode1.subtitle)
      end
    end
  end
end
