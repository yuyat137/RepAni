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
import { mapGetters, mapActions } from "vuex"
import AnimeList from './components/AnimeList'
import TermList from './components/TermList'
/* import Mixin from '../../packs/mixins/mixin' */

export default {
  name: "AnimeIndex",
  components: {
    AnimeList,
    TermList,
  },
  data() {
    return {
      selectTerm: "",
    }
  },
  /* mixins: [Mixin], */
  computed: {
    ...mapGetters("animes", ["animes"]),
    ...mapGetters("terms", ["terms"])
  },
  async created() {
    await this.fetchTerms()
    await this.handleSetSelectTerm()
    this.handleShowSelectTerm(this.selectTerm) 
  },
  methods: {
    ...mapActions("animes", ["fetchAnimes"]),
    ...mapActions("terms", ["fetchTerms"]),
    handleStartTweetReplay(anime) {
      this.$router.push({name: 'ReplayIndex'})
    },
    handleSetSelectTerm() {
      for(let i=0; i<this.terms.length; i++) {
        if(this.terms[i].now == true) {
          this.selectTerm = this.terms[i]
          break;
        }
      }
    },
    handleShowSelectTerm(term) {
      this.selectTerm = term;
      this.fetchAnimes(term);
      window.scrollTo({
        top: 0,
        behavior: "instant"
      });
    }
  }
}
</script>
