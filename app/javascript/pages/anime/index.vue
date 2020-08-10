<template>
  <div>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <h2>{{ selectTerm.year }}年{{ selectTerm.season_ja }}</h2>
    <AnimeList
      :animes="animes"
      @select-anime="handleStartTweetReplay"
    />
    <h2>シーズン一覧</h2>
    <TermList
      :terms="terms"
      @select-term="handleShowSelectTerm"
    />
  </div>
</template>

<script>
/* import Mixin from '../../packs/mixins/mixin' */
import AnimeList from './components/AnimeList'
import TermList from './components/TermList'

export default {
  name: "AnimeIndex",
  components: {
    AnimeList,
    TermList,
  },
  data() {
    return {
      animes: [],
      terms: [],
      selectTerm: null,
    }
  },
  /* mixins: [Mixin], */
  computed: {
  },
  async created() {
    await this.fetchTerms();
    await this.handleSetSelectTerm()
    this.handleShowSelectTerm(this.selectTerm) 
  },
  methods: {
    async fetchTerms() {
      await this.$axios.get("terms")
        .then(res => this.terms = res.data)
        .catch(err => console.log(err.status));
    },
    handleStartTweetReplay(anime) {
      this.$router.push({name: 'ReplayIndex'})
    },
    handleSetSelectTerm(term) {
      for(let i=0; i<this.terms.length; i++) {
        if(this.terms[i].now == true) {
          this.selectTerm = this.terms[i]
          break;
        }
      }
    },
    handleShowSelectTerm(term) {
      console.log("term")
      console.log(term)
      this.selectTerm = term;
      this.$axios.get("animes", { params: term })
        .then(res => this.animes = res.data)
        .catch(err => console.log(err.status));
      window.scrollTo({
        top: 0,
        behavior: "instant"
      });
    }
  }
}
</script>
