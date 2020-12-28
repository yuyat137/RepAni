<template>
  <div>
    <v-card class="pa-2">
      <div class="d-flex justify-space-between">
        <div>
          <div class="d-inline-block">
            <img
              :src="tweet.profile_image_url"
              class="rounded-circle"
            >
          </div>
          <div class="d-inline-block">
            <div class="block">
              @{{ tweet.screen_name }}
            </div>
            <div
              class="block"
              style="white-space: nowrap"
            >
              {{ tweet.name }}
            </div>
          </div>
        </div>
        <div>
          <img
            src="../../../assets/Twitter_Logo_Blue.png"
            width="35px"
            height="35px"
          >
        </div>
      </div>
      <p style="white-space: pre-line">
        {{ tweet.text }}
      </p>
      <div>
        <img
          v-if="tweet.image_url1"
          :src="tweet.image_url1"
          class="d-inline-block"
          width="40%"
        >
        <img
          v-if="tweet.image_url2"
          :src="tweet.image_url2"
          class="d-inline-block"
          width="40%"
        >
        <img
          v-if="tweet.image_url3"
          :src="tweet.image_url3"
          class="d-inline-block"
          width="40%"
        >
        <img
          v-if="tweet.image_url4"
          :src="tweet.image_url4"
          class="d-inline-block"
          width="40%"
        >
      </div>
      <div class="d-flex justify-space-between">
        <div>
          <img
            src="../../../assets/reply.png"
            class="ml-2"
            width="14px"
            height="12px"
          >
          <img
            src="../../../assets/retweet.png"
            class="ml-15"
            width="17px"
            height="11px"
          >
          <img
            src="../../../assets/favorite.png"
            class="ml-15"
            width="14px"
            height="12px"
          >
        </div>
        <div>
          {{ tweeted_at() }}
        </div>
      </div>
    </v-card>
  </div>
</template>
<script>
//memo:  onError="this.onerror=null;this.src='https://pbs.twimg.com/profile_images/1061815280442105857/RLpkoVSp_normal.jpg';"
import moment from 'moment';
require("moment-duration-format");

export default {
  name: "Tweet",
  props: {
    tweet: {
      type: Object,
      required: true
    },
  },
  data() {
    return {
    }
  },
  methods: {
    tweeted_at() {
      return String(moment(new Date(this.tweet.tweeted_at)).format("YYYY/MM/DD HH:mm:ss"))
    }
  }
}
</script>
