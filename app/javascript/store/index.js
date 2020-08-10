import Vue from 'vue'
import Vuex from 'vuex'
import animes from './modules/animes'
import terms from './modules/terms'

Vue.use(Vuex)

const store = new Vuex.Store({
  modules: {
    animes,
    terms,
  },
})

export default store
