<template>
  <div>
    <p v-if="anime.public_url">
      公式サイト: <a
        :href="publicUrl"
        rel="noopener"
        target="_blank"
      >{{ publicUrl }}</a>
    </p>
    <p v-if="anime.twitter_account">
      Twitterアカウント: <a
        :href="twitterAccount"
        rel="noopener"
        target="_blank"
      >{{ twitterAccount }}</a>
    </p>
    <p v-if="anime.twitter_hash_tag">
      Twitterハッシュタグ: #{{ this.anime.twitter_hash_tag }}
    </p>
    <p v-if="episode.broadcast_datetime">
      ツイート取得日: {{ displayDateTime(this.episode.broadcast_datetime) }}
    </p>
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
  computed: {
    publicUrl(){
      return this.anime.public_url
    },
    twitterAccount(){
      return "https://twitter.com/" + this.anime.twitter_account
    },
  },
  methods: {
    displayDateTime (date) {
      return String(moment(new Date(date)).format("YYYY年MM月DD日  HH時mm分"))
    },
  },
}
</script>
