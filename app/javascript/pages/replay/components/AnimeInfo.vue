<template>
  <div id="anime_info">
    <p v-if="anime.public_url">公式サイト {{ this.anime.public_url }}</p>
    <p v-if="anime.twitter_account">Twitterアカウント https://twitter.com/{{ this.anime.twitter_account }}</p>
    <p v-if="anime.twitter_hash_tag">Twitterハッシュタグ #{{ this.anime.twitter_hash_tag }}</p>
    <p v-if="episode.broadcast_datetime">ツイート取得日 {{ displayDateTime(this.episode.broadcast_datetime) }}</p>
  </div>
</template>
<script>
import moment from 'moment';

export default {
  name: "AnimeInfo",
  props: {
    anime: {
      type: Object,
      required: true
    },
    episode: {
      type: Object,
      required: true
    },
  },
  methods: {
    displayDateTime (date) {
      return String(moment(new Date(date)).format("YYYY/MM/DD HH時mm分"))
    }
  },
}
</script>
<style scoped>
#anime_info {
  margin-top: 50px;
}
</style>
