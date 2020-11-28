<template>
  <div>
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
        <p>{{ displayBarTime }}/{{ displayMaxTime }}</p>
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
        id="timer_stop"
        small
        color="error"
        @click="timerStop"
      >
        Stop
      </v-btn>
      <div class="ml-2 mt-2">
        <v-btn
          id="move_few_back"
          small
          color="primary"
          @click="moveFewSeconds(-10)"
        >
          10秒戻る
        </v-btn>
        <v-btn
          id="move_few_front"
          small
          color="error"
          @click="moveFewSeconds(10)"
        >
          10秒進む
        </v-btn>
      </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment';
import VueSlider from 'vue-slider-component'
import 'vue-slider-component/theme/antd.css'
require("moment-duration-format");

const ONE_VALUE = 1
const MINUTES_TO_SECONDS = 60
const SECONDS_TO_MSEC = 1000
const CONVERTING_PERCENT_AND_PROPORTION = 100

//NOTE: 変数名 => Timeは12:00:00のような時刻を、Msecはミリ秒を表すという使い分けをしています
//NOTE: 時刻計算方法 => (バーのミリ秒) = (スタート時のミリ秒) + (今の時刻 - スタートした時刻).ミリ秒に変換

export default {
  name: "Timer",
  components: {
    VueSlider,
  },
  props: {
    episode: {
      type: Object,
      required: true
    },
  },
  data() {
    return {
      value: 0,
      prevValue: 0,
      startingTime: "",
      msecWhenStarted: 0,
      displayMaxTime: "",
      displayBarTime: "00:00:00",
      maxAirMsec: "",
      barMsec: 0,
      timerOn: false,
      timerObj: "",
    }
  },
  watch: {
    value: function() {
      if(this.userOperateBar()) {
        this.timerStop()
      }
      if(!this.timerOn) {
        this.displayBarTime = moment.duration(this.convertValueToMsec()).format("hh:mm:ss", { trim: false, trunc: true })
        this.msecWhenStarted = this.barMsec = this.convertValueToMsec()
      }
      this.prevValue = this.value
    }
  },
  async created() {
    this.maxAirMsec = this.episode.air_time * MINUTES_TO_SECONDS * SECONDS_TO_MSEC
    this.displayMaxTime = moment.duration(this.maxAirMsec).format("hh:mm:ss", { trim: false, trunc: true })
    this.timerObj = setInterval(()=>{
      if(this.timerOn){
        this.timer()
      }
    }, 100)
  },
  methods: {
    timer() {
      if(this.barMsec < this.episode.air_time * MINUTES_TO_SECONDS * SECONDS_TO_MSEC) {
        let moment = require('moment')
        this.barMsec = this.msecWhenStarted + Number(moment.duration(moment().diff(this.startingTime)).format("S", { useGrouping: false }))
        this.displayBarTime = moment.duration(this.barMsec).format("hh:mm:ss", { trim: false, trunc: true })
        this.moveBar()
      } else {
        this.timerStop()
      }
    },
    timerStart() {
      this.timerOn = true
      this.startingTime = moment()
    },
    timerStop() {
      this.timerOn = false
      this.msecWhenStarted = this.barMsec
    },
    moveBar() {
      this.value = (this.barMsec / this.maxAirMsec * CONVERTING_PERCENT_AND_PROPORTION)
    },
    userOperateBar() {
      let diffValue = Math.abs(this.prevValue - this.value)
      if(diffValue > ONE_VALUE){
        return true
      } else {
        return false
      }
    },
    convertValueToMsec() {
      return (this.maxAirMsec * (this.value / CONVERTING_PERCENT_AND_PROPORTION))
    },
    moveFewSeconds(fewSeconds) {
      this.timerOn = false
      // TODO: maxMsecは今のところ文字列が入ってないか、minMsecはそもそも変数として定義する必要あるのか
      let minMsec = 0
      let maxMsec = this.maxAirMsec
      let moveMsec = fewSeconds * SECONDS_TO_MSEC
      let msecAfterMove = this.barMsec + moveMsec
      if(msecAfterMove < minMsec) {
        msecAfterMove = minMsec
      } else if(msecAfterMove > maxMsec) {
        msecAfterMove = maxMsec
      }
      this.msecWhenStarted = this.barMsec = msecAfterMove
      this.displayBarTime = moment.duration(this.barMsec).format("hh:mm:ss", { trim: false, trunc: true })
      this.moveBar()
    },
  },
}
</script>
