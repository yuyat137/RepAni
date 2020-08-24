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
        <vue-slider v-model="value" :tooltip="'none'" />
        <p>{{ value }}%</p>
      </div>
    </v-col>
    <p>現在時刻：{{ progressTime }}</p>
    <div
      v-for="tweet in tweets"
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
      tweets: [],
      progressTime: moment(),
    }
  },
  created() {
    this.fetchTweets();
    this.fetchAnimeAndEpisode();
  },
  methods: {
    fetchTweets() {
      //this.$axios.get("tweets", { params:  })
      this.$axios.get("tweets")
        .then(res => this.tweets = res.data)
        .catch(err => console.log(err.status));
    },
    fetchAnimeAndEpisode() {
      this.$axios.get("episodes/info", {params: {episode_id: this.$route.params.episodeId }})
        .then(res => {
          this.selectAnime = res.data.anime
          this.selectEpisode = res.data.episode
        })
        .catch(err => console.log(err.status));
    },
  }
}
</script>
