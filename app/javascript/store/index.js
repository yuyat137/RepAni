import Vue from 'vue'
import Vuex from 'vuex'
import animes from './modules/animes'

Vue.use(Vuex)

const store = new Vuex.Store({
  modules: {
    animes,
  },
})

export default store
