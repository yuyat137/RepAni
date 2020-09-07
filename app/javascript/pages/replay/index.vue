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
        <p>{{ formatProgressTime }}/{{ formatMaxTime }}</p>
      </div>
    </v-col>
    <div class="ml-2">
      <v-btn
        v-if="!timerOn"
        id="timer_start"
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
      <div class="ml-2 mt-2">
        <v-btn
          small
          color="primary"
          @click="moveFewSeconds(-10)"
        >
          10秒戻る
        </v-btn>
        <v-btn
          small
          color="error"
          @click="moveFewSeconds(10)"
        >
          10秒進む
        </v-btn>
      </div>
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
const MINUTES_TO_SECONDS = 60
const SECONDS_TO_MSEC = 1000
const CONVERTING_PERCENT_AND_PROPORTION = 100

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
      startTimerTime: "",
      progressTimeMsec: 0,
      accumulatedTimeMsecByTimerStart: 0,
      formatProgressTime: "00:00:00",
      formatMaxTime: "",
      timerOn: false,
      timerObj: "",
      maxAirTimeMsec: ""
    }
  },
  watch: {
    formatProgressTime: function() {
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
        this.formatProgressTime = moment.duration(this.convertValueToMsec()).format("hh:mm:ss", { trim: false, trunc: true })
        this.accumulatedTimeMsecByTimerStart = this.progressTimeMsec = this.convertValueToMsec()
      }
      this.momentBeforeValue = this.value
    }
  },
  async created() {
    await this.fetchAnimeAndEpisode()
    this.maxAirTimeMsec = this.selectEpisode.air_time * MINUTES_TO_SECONDS * SECONDS_TO_MSEC
    this.formatMaxTime = moment.duration().format("hh:mm:ss", { trim: false, trunc: true })
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
      if(this.progressTimeMsec < this.selectEpisode.air_time * MINUTES_TO_SECONDS * SECONDS_TO_MSEC) {
        let moment = require('moment')
        this.progressTimeMsec = this.accumulatedTimeMsecByTimerStart + Number(moment.duration(moment().diff(this.startTimerTime)).format("S", { useGrouping: false }))
        this.formatProgressTime = moment.duration(this.progressTimeMsec).format("hh:mm:ss", { trim: false, trunc: true })
        this.moveProgressBar()
      } else {
        this.timerStop()
      }
    },
    timerStart() {
      this.timerOn = true
      this.startTimerTime = moment()
    },
    timerStop() {
      this.timerOn = false
      this.accumulatedTimeMsecByTimerStart = this.progressTimeMsec
    },
    moveProgressBar() {
      this.value = (this.progressTimeMsec / this.maxAirTimeMsec * CONVERTING_PERCENT_AND_PROPORTION)
    },
    userOperateProgressBar() {
      if(Math.abs(this.momentBeforeValue - this.value) > ONE_PERCENT){
        return true
      } else {
        return false
      }
    },
    convertValueToMsec() {
      return (this.maxAirTimeMsec * (this.value / CONVERTING_PERCENT_AND_PROPORTION))
    },
    moveFewSeconds(fewSeconds) {
      this.timerOn = false
      let minTime = 0
      let maxTime = this.maxAirTimeMsec
      let timeAfterMoveMsec = this.progressTimeMsec + fewSeconds * SECONDS_TO_MSEC
      if(timeAfterMoveMsec < minTime) {
        timeAfterMoveMsec = minTime
      } else if(timeAfterMoveMsec > maxTime) {
        timeAfterMoveMsec = maxTime
      }
      this.accumulatedTimeMsecByTimerStart = this.progressTimeMsec = timeAfterMoveMsec
      this.formatProgressTime = moment.duration(this.progressTimeMsec).format("hh:mm:ss", { trim: false, trunc: true })
      this.moveProgressBar()
    },
  },
}
</script>
