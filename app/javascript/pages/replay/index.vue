<template>
  <div>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <h2>ツイートのリプレイ</h2>
    <h2>{{ selectAnime }}</h2>
    <h2>{{ selectEpisode }}</h2>
    <div
      v-for="tweet in tweets"
      :key="tweet.id"
    >
      {{ tweet.text }}
    </div>
  </div>
</template>

<script>
export default {
  name: "ReplayIndex",
  data() {
    return {
      episodeId: this.$route.params.episodeId,
      episode: "",
      selectAnime: "",
      selectEpisode: "",
      tweets: [],
    }
  },
  created() {
    this.fetchTweets();
    this.fetchAnimeAndEpisode();
  },
  methods: {
    fetchTweets() {
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
    }
  }
}
</script>
