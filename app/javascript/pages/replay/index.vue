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
          {{ tweet.text }}
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import Timer from './components/Timer'

export default {
  name: "ReplayIndex",
  components: {
    Timer,
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
    }
  },
  watch: {
    stackTweets: function() {
      if(this.stackTweets.length <= 10){
        this.fetchTweets();
      }
    },
  },
  async created() {
    await this.fetchAnimeAndEpisode()
    this.fetchTweets()
    this.$watch(
      function () {
        return this.$refs.timer.$data.progressTimeMsec
      },
      function() {
        this.stackToShowTweets()
        if(this.stackTweets.length < 100 && !this.fetchLastTweet) {
          fetchTweets()
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
    fetchTweets() {
      // 実際の実装では=とせずstackTweetsに追加するようにする
      this.$axios.get("tweets", {params: {episode_id: this.selectEpisode.id, progress_time_msec: this.$refs.timer.$data.progressTimeMsec}})
        .then(res => {
          this.stackTweets = res.data.tweets
          this.fetchLastTweet = res.data.fetch_last_tweet
        })
        .catch(err => console.log(err.status));
    },
    stackToShowTweets(){
      while (this.stackTweets[0].progress_time_msec <= this.$refs.timer.$data.progressTimeMsec) {
        this.showTweets.unshift(this.stackTweets.shift());
      }
    },
  },
}
</script>
