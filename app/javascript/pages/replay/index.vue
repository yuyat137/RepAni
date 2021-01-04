<template>
  <div>
    <v-container>
      <v-row>
        <v-col
          v-if="selectEpisode"
          cols="6"
        >
          <v-breadcrumbs :items="items">
            <template v-slot:item="{ item }">
              <v-breadcrumbs-item
                :href="item.href"
                :disabled="item.disabled"
              >
                {{ item.text.toUpperCase() }}
              </v-breadcrumbs-item>
            </template>
          </v-breadcrumbs>
          <v-col offset="1">
            <h2>{{ selectAnime.title }}</h2>
            <h2>
              {{ selectEpisode.num }}話
              <span v-if="selectEpisode.subtitle">
                『{{ selectEpisode.subtitle }}』
              </span>
            </h2>
            <Timer
              ref="timer"
              :episode="selectEpisode"
              id="timer"
            />
            <AnimeInfo
              :anime="selectAnime"
              :episode="selectEpisode"
              id="anime_info"
            />
          </v-col>
        </v-col>
        <v-col
          cols="5"
        >
          <div
            v-for="tweet in showTweets"
            :key="tweet.id"
            class="my-5"
          >
            <Tweet :tweet="tweet" />
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import Timer from './components/Timer'
import Tweet from './components/Tweet'
import AnimeInfo from './components/AnimeInfo'
const CHECK_INTERVAL_TIME_MSEC = 300

export default {
  name: "ReplayIndex",
  components: {
    Timer,
    Tweet,
    AnimeInfo,
  },
  data() {
    return {
      episodeId: this.$route.params.episodeId,
      episode: "",
      selectAnime: "",
      selectEpisode: "",
      stackTweets: [],
      showTweets: [],
      fetchLastTweet: false,
      prevBarMsec: 0,
      items: [
        {
          text: 'トップ',
          disabled: false,
          href: '/',
        },
        {
          text: '放送時期',
          disabled: false,
          href: '/anime',
        },
        {
          text: 'アニメ',
          disabled: true,
          href: '',
        },
      ]
    }
  },
  async created() {
    await this.fetchAnimeAndEpisode()
    await this.fetchTweets()
    this.$watch(
      function () {
        return this.$refs.timer.$data.barMsec
      },
      function() {
        if(this.$refs.timer.$data.timerOn && (this.$refs.timer.$data.barMsec - this.prevBarMsec) > CHECK_INTERVAL_TIME_MSEC) {
          this.stackToShowTweets()
          this.prevBarMsec = this.$refs.timer.$data.barMsec
        }
      }
    )
    this.$watch(
      function () {
        return this.$refs.timer.$data.timerOn
      },
      function() {
        if (this.$refs.timer.$data.timerOn) {
          // タイマーが始めったらshowTweetsを空にする
          this.showTweets = []
          this.prevBarMsec = this.$refs.timer.$data.barMsec
          this.fetchTweets()
        } else {
          // タイマーが止まったらstackTweetsを空にする
          this.stackTweets = []
          this.fetchLastTweet = false
        }
      }
    )
    /*
    this.$watch(
      function () {
        return (this.$refs.timer.$data.stackTweets < 100) && (!this.fetchLastTweet)
      },
      function() {
        // ここのメソッド内は未実装
        // ツイート追加で取得する
      }
    )
    */
  },
  methods: {
    async fetchAnimeAndEpisode() {
      await this.$axios.get("episodes/info", {params: {episode_id: this.$route.params.episodeId }})
        .then(res => {
          this.selectAnime = res.data.anime
          this.selectEpisode = res.data.episode
        })
        .catch(err => console.log(err.status));
    },
    async fetchTweets() {
      // 実際の実装では=とせずstackTweetsに追加するようにする
      //TODO: パラメーターのprogressを取りたい
      let tweet_id = ""
      if(this.stackTweets.length) {
        tweet_id = this.stackTweets.last.id
      }
      await this.$axios.get("tweets", {params: {episode_id: this.selectEpisode.id, tweet_id: tweet_id, progress_time_msec: this.$refs.timer.$data.barMsec}})
        .then(res => {
          this.stackTweets = res.data.tweets
          this.fetchLastTweet = res.data.fetch_last_tweet
          res = null
        })
        .catch(err => console.log(err.status));
    },
    stackToShowTweets(){
      while (this.stackTweets[0].progress_time_msec <= this.$refs.timer.$data.barMsec && !this.showTweets.includes(this.stackTweets[0])) {
        this.showTweets.unshift(this.stackTweets.shift());
      }
    },
  },
}
</script>
<style scoped>
#timer {
  margin-top: 40px;
}
#anime_info {
  margin-top: 60px;
}
</style>
