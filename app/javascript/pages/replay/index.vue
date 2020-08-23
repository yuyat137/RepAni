<template>
  <div>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <h2>ツイートのリプレイ</h2>
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
      tweets: [],
    }
  },
  created() {
    this.fetchTweets();
  },
  methods: {
    fetchTweets() {
      this.$axios.get("tweets")
        .then(res => this.tweets = res.data)
        .catch(err => console.log(err.status));
    },
  }
}
</script>
