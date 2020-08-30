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
        <p>{{ formatStorageTime }}/{{ formatMaxTime }}</p>
      </div>
    </v-col>
    <div class="ml-2">
      <v-btn
        v-if="!timerOn"
        small
        color="primary"
        @click="timerStart"
      >
        Start
      </v-btn>
      <v-btn
        v-if="timerOn"
        small
        color="error"
        @click="timerStop"
      >
        Stop
      </v-btn>
    </div>
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
require("moment-duration-format");

const ONE_PERCENT = 1

export default {
  name: "ReplayIndex",
  components: {
    VueSlider
  },
  data() {
    return {
      value: 0,
      momentBeforeValue: 0,
      episodeId: this.$route.params.episodeId,
      episode: "",
      selectAnime: "",
      selectEpisode: "",
      stackTweets: [],
      showTweets: [],
      startTime: "",
      countTimeMsec: 0,
      storageTimeMsec: 0,
      formatStorageTime: "",
      timerOn: false,
      timerObj: "",
      formatMaxTime: "",
    }
  },
  watch: {
    formatStorageTime: function() {
      this.stackToShowTweets()
    },
    stackTweets: function() {
      if(this.stackTweets.length <= 10){
        this.fetchTweets();
      }
    },
    value: function() {
      if(this.userOperateProgressBar()) {
        this.timerStop()
      }
      if(!this.timerOn) {
        this.formatStorageTime = moment.duration(this.convertValueToMsec()).format("hh:mm:ss", { trim: false, trunc: true })
        this.storageTimeMsec = this.convertValueToMsec()
      }
      this.momentBeforeValue = this.value
    }
  },
  async created() {
    await this.fetchAnimeAndEpisode()
    this.formatMaxTime = moment.duration(this.selectEpisode.air_time * 60 * 1000).format("hh:mm:ss", { trim: false, trunc: true })
    this.fetchTweets()
    this.timerObj = setInterval(()=>{
      if(this.timerOn){
        this.timer()
      }
    }, 100)
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
    timer() {
      let moment = require('moment')
      this.countTimeMsec = this.storageTimeMsec + Number(moment.duration(moment().diff(this.startTime)).format("S", { useGrouping: false }))
      this.formatStorageTime = moment.duration(this.countTimeMsec).format("hh:mm:ss", { trim: false, trunc: true })
      this.moveProgressBar()
    },
    timerStart() {
      this.timerOn = true
      this.startTime = moment()
    },
    timerStop() {
      this.timerOn = false
      this.storageTimeMsec = this.countTimeMsec
    },
    moveProgressBar() {
      //一度storageTimeMsecで初期化しているからその辺問題ないか不安
      this.value = (this.countTimeMsec / (this.selectEpisode.air_time * 60 * 1000) * 100)
    },
    userOperateProgressBar() {
      if(Math.abs(this.momentBeforeValue - this.value) > ONE_PERCENT){
        return true
      } else {
        return false
      }
    },
    convertValueToMsec() {
      return (this.selectEpisode.air_time * 60 * 1000 * this.value / 100)
    },
  },
}
</script>
