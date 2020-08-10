import axios from '../../plugins/axios'

const state = {
  terms: []
}

const getters = {
  terms: state => state.terms
}

const mutations = {
  setTerms: (state, terms) => {
    state.terms = terms
  },
}

const actions = {
  async fetchTerms({ commit }) {
    await axios.get("terms")
      .then(res => {
        commit("setTerms", res.data)
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
