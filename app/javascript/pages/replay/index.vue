<template>
  <div>
    <v-row>
      <v-col
        v-if="selectEpisode"
        cols="5"
        offset="1"
      >
        <router-link :to="{ name: 'TopIndex' }">
          Topへ
        </router-link>
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
        />
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
  </div>
</template>

<script>
import Timer from './components/Timer'
import Tweet from './components/Tweet'
const CHECK_INTERVAL_TIME_MSEC = 300

export default {
  name: "ReplayIndex",
  components: {
    Timer,
    Tweet,
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
      processTimeJustBeforeMsec: 0,
    }
  },
  async created() {
    await this.fetchAnimeAndEpisode()
    await this.fetchTweets()
    this.$watch(
      // 時間が進むにつれツイートを表示
      function () {
        return this.$refs.timer.$data.progressTimeMsec
      },
      function() {
        if(this.$refs.timer.$data.timerOn && (this.$refs.timer.$data.progressTimeMsec - this.processTimeJustBeforeMsec) > CHECK_INTERVAL_TIME_MSEC) {
          this.stackToShowTweets()
          this.processTimeJustBeforeMsec = this.$refs.timer.$data.progressTimeMsec
        }
      }
    )
    this.$watch(
      // タイマーが止まったらstackTweetsを空にする
      // タイマーが始めったらshowTweetsを空にする
      function () {
        return this.$refs.timer.$data.timerOn
      },
      function() {
        if (this.$refs.timer.$data.timerOn) {
          this.showTweets = []
          this.processTimeJustBeforeMsec = this.$refs.timer.$data.progressTimeMsec
        } else {
          this.stackTweets = []
          this.fetchLastTweet = false
        }
      }
    )
    this.$watch(
      // タイマースタート時、もしくはstackTweetsが少なくなったら補充
      function () {
        /* return this.$refs.timer.$data.timerOn || this.$refs.timer.$data.stackTweets < 100 */
        return this.$refs.timer.$data.timerOn
      },
      function() {
        if(!this.fetchLastTweet) {
          this.fetchTweets()
        }
      }
    )
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
      await this.$axios.get("tweets", {params: {episode_id: this.selectEpisode.id, progress_time_msec: this.$refs.timer.$data.progressTimeMsec}})
        .then(res => {
          this.stackTweets = res.data.tweets
          this.fetchLastTweet = res.data.fetch_last_tweet
        })
        .catch(err => console.log(err.status));
    },
    stackToShowTweets(){
      while (this.stackTweets[0].progress_time_msec <= this.$refs.timer.$data.progressTimeMsec && !this.showTweets.includes(this.stackTweets[0])) {
        this.showTweets.unshift(this.stackTweets.shift());
      }
    },
  },
}
</script>
