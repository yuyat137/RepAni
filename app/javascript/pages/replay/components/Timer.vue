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
        :clickable=true
        :drag-on-click=true
        @dragging=dragBar(value)
        @drag-end=dragBar(value)
      />
      <p>{{ displayBarTime }}/{{ displayMaxTime }}</p>
    </div>
    <div
      class="ml-2 pt-3"
    >
      <v-btn
        id="move_few_back"
        small
        color="grey lighten-3"
        @click="moveFewSeconds(-10)"
        class="mr-3"
      >
        <i class="fas fa-backward mr-1"></i>
        10秒戻る
      </v-btn>
      <v-btn
        v-if="!timerOn"
        id="timer_start"
        small
        color="primary"
        @click="timerStart"
      >
        スタート
        <i class="far fa-play-circle ml-1"></i>
      </v-btn>
      <v-btn
        v-if="timerOn"
        id="timer_stop"
        small
        color="error"
        @click="timerStop"
      >
        ストップ
        <i class="far fa-stop-circle ml-1"></i>
      </v-btn>
      <v-btn
        id="move_few_front"
        small
        color="grey lighten-3"
        @click="moveFewSeconds(10)"
        class="ml-3"
      >
        10秒進む
        <i class="fas fa-forward ml-1"></i>
      </v-btn>
    </div>
  </div>
</template>
<script>
import moment from 'moment';
import VueSlider from 'vue-slider-component'
import 'vue-slider-component/theme/antd.css'
require("moment-duration-format");

const MINUTES_TO_SECONDS = 60
const SECONDS_TO_MSEC = 1000
const CONVERTING_PERCENT_AND_PROPORTION = 100
const MIN_MSEC = 0

//NOTE: 変数名について => 末尾がTimeの変数は12:00:00のような時刻を、末尾がMsecの変数はミリ秒を表しています
//NOTE: 時刻計算方法 => (バーのミリ秒) = (スタート時のミリ秒) + (今の時刻 - スタートした時刻)のミリ秒

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
    displayBarTime: function(){
      if(this.timerOn) {
        //NOTE: moveBarProcessメソッド内に下記処理を書くと、100ミリ秒ごと実行され、ドラッグ時にドラッグ先のvalueにならない不具合が生じる。
        this.value = (this.barMsec / this.maxAirMsec * CONVERTING_PERCENT_AND_PROPORTION)
      }
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
      this.msecWhenStarted = this.barMsec
      this.timerOn = true
      this.startingTime = moment()
    },
    timerStop() {
      this.timerOn = false
      this.msecWhenStarted = this.barMsec
    },
    dragBar(value){
      this.timerStop()
      this.moveBarProcess(this.convertBarValueToMsec(value))
    },
    moveBarProcess(msecAfterMove) {
      this.barMsec = msecAfterMove
      this.displayBarTime = this.msecToDisplayTime(this.barMsec)
    },
    convertBarValueToMsec(value) {
      return (this.maxAirMsec * (value / CONVERTING_PERCENT_AND_PROPORTION))
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
