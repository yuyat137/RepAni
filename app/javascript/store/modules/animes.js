import axios from '../../plugins/axios'

const state = {
  animes: []
}

const getters = {
  animes: state => state.animes
}

const mutations = {
  setAnimes: (state, animes) => {
    state.animes = animes
  },
}

const actions = {
  fetchAnimes({ commit }, term) {
    axios.get('animes', { params: term })
      .then(res => {
        commit('setAnimes', res.data)
      })
      .catch(err => console.log(err.response));
  },
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
} 
