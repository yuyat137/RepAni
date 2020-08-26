<template>
  <div>
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
    <v-col
      md="6"
      offset-md="3"
    >
      <div width="60%">
        <vue-slider
          v-model="value"
          :tooltip="'none'"
          :min="0"
          :max="100"
          :interval="0.1"
        />
        <p>{{ value }}%</p>
      </div>
    </v-col>
    <p>現在時刻：{{ progressTime }}</p>
    <div
      v-for="tweet in showTweets"
      :key="tweet.id"
      class="my-5"
    >
      {{ tweet.text }}
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import VueSlider from 'vue-slider-component'
import 'vue-slider-component/theme/antd.css'

export default {
  name: "ReplayIndex",
  components: {
    VueSlider
  },
  data() {
    return {
      value: 0,
      episodeId: this.$route.params.episodeId,
      episode: "",
      selectAnime: "",
      selectEpisode: "",
      stackTweets: [],
      showTweets: [],
      progressTime: moment(),
    }
  },
  async created() {
    await this.fetchAnimeAndEpisode();
    this.fetchTweets();
    this.progressTime = setInterval(()=>{this.progressTime = moment()},1000)
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
      this.$axios.get("tweets", {params: {episode_id: this.selectEpisode.id}})
        .then(res => this.stackTweets = res.data)
        .catch(err => console.log(err.status));
    },
    stackToShowTweets(){
      let tweet = this.stackTweets.shift()
      if(tweet) {
        this.showTweets.unshift(tweet);
      }
    },
  },
  watch: {
    progressTime() {
      this.stackToShowTweets()
    },
    stackTweets() {
      if(this.stackTweets.length <= 10){
        this.fetchTweets();
      }
    },
  },
}
</script>
