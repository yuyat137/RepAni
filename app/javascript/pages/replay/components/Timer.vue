<template>
  <div>
    <div class="my-5">
      <vue-slider
        v-model="value"
        :tooltip="'none'"
        :min="0"
        :max="100"
        :interval="0.1"
        width="70%"
      />
      <p>{{ displayBarTime }}/{{ displayMaxTime }}</p>
    </div>
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
const MIN_MSEC = 0

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
      barMsec: 0,
      displayBarTime: "00:00:00",
      maxAirMsec: 0,
      displayMaxTime: "",
      msecWhenStarted: 0,
      timerOn: false,
      timerObj: "",
    }
  },
  watch: {
    value: function() {
      if(this.isBarOperated()) {
        this.timerStop()
        this.moveBarProcess(this.convertBarValueToMsec())
      }
      this.prevValue = this.value
    }
  },
  async created() {
    this.maxAirMsec = this.episode.air_time * MINUTES_TO_SECONDS * SECONDS_TO_MSEC
    this.displayMaxTime = this.msecToDisplayTime(this.maxAirMsec)
    this.timerObj = setInterval(()=>{
      if(this.timerOn){
        this.timer()
      }
    }, 100)
  },
  methods: {
    timer() {
      if(this.barMsec < this.maxAirMsec) {
        let msecAfterMove = this.msecWhenStarted + Number(moment.duration(moment().diff(this.startingTime)).format("S", { useGrouping: false }))
        this.moveBarProcess(msecAfterMove)
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
    moveBarProcess(msecAfterMove) {
      this.barMsec = msecAfterMove

      if(!this.timerOn) {
        this.msecWhenStarted = this.barMsec
      }

      this.displayBarTime = this.msecToDisplayTime(this.barMsec)
      this.value = (this.barMsec / this.maxAirMsec * CONVERTING_PERCENT_AND_PROPORTION)
    },
    isBarOperated() {
      // TODO: ユーザーがプログレスバーを操作したと判断するのは以下のコードで良いのか悩み中
      let diffValue = Math.abs(this.prevValue - this.value)
      if(diffValue > ONE_VALUE){
        return true
      } else {
        return false
      }
    },
    convertBarValueToMsec() {
      return (this.maxAirMsec * (this.value / CONVERTING_PERCENT_AND_PROPORTION))
    },
    moveFewSeconds(moveSeconds) {
      this.timerStop()
      let msecAfterMove = this.barMsec + moveSeconds * SECONDS_TO_MSEC

      if(msecAfterMove < MIN_MSEC) {
        msecAfterMove = MIN_MSEC
      } else if(msecAfterMove > this.maxAirMsec) {
        msecAfterMove = this.maxAirMsec
      }

      this.moveBarProcess(msecAfterMove)
    },
    msecToDisplayTime(msec) {
      return moment.duration(msec).format("hh:mm:ss", { trim: false, trunc: true })
    }
  },
}
</script>
