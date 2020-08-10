import axios from '../../plugins/axios'

const state = {
  terms: [],
  selectTerm: ""
}

const getters = {
  terms: state => state.terms,
  selectTerm: state => state.selectTerm
}

const mutations = {
  setTerms: (state, terms) => {
    state.terms = terms
  },
  setSelectTerm: (state, term) => {
    state.selectTerm = term
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
  setSelectTerm({ commit }, term) {
    commit("setSelectTerm", term);
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
} 
