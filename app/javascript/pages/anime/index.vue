<template>
  <div>
    <v-container>
      <v-breadcrumbs :items="items">
        <template v-slot:item="{ item }">
          <v-breadcrumbs-item
            :href="item.href"
            :disabled="item.disabled"
          >
            {{ item.text.toUpperCase() }}
          </v-breadcrumbs-item>
        </template>
      </v-breadcrumbs>
      <v-row>
        <v-col cols="3">
          <h2>放送時期</h2>
          <TermList
            :terms="terms"
            @select-term="handleShowSelectTerm"
          />
        </v-col>
        <v-col cols="6">
          <h2>{{ selectTerm.year }}年{{ selectTerm.season_ja }}</h2>
          <AnimeList
            :animes="animes"
            @select-anime="handleShowAnimeEpisodesDialog"
          />
        </v-col>
      </v-row>
      <AnimeEpisodesDialog
        ref="dialog"
        :anime="selectAnime"
        :episodes="episodes"
      />
    </v-container>
  </div>
</template>

<script>
import AnimeList from './components/AnimeList'
import TermList from './components/TermList'
import AnimeEpisodesDialog from "./components/AnimeEpisodesDialog"

export default {
  name: "AnimeIndex",
  components: {
    AnimeList,
    TermList,
    AnimeEpisodesDialog,
  },
  data() {
    return {
      animes: [],
      terms: [],
      selectTerm: new Object,
      selectAnime: new Object,
      episodes: new Array,
      items: [
        {
          text: 'トップ',
          disabled: false,
          href: '/',
        },
        {
          text: '放送時期',
          disabled: true,
          href: '',
        },
      ]
    }
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
    async handleShowAnimeEpisodesDialog(anime) {
      this.selectAnime = anime;
      this.fetchEpisodes();
      this.$refs.dialog.open();
    },
    fetchEpisodes() {
      this.$axios.get("episodes", { params: this.selectAnime })
        .then(res => this.episodes = res.data)
        .catch(err => console.log(err.status));
    },
    // ここの引数いる？あとで確認
    handleSetSelectTerm(term) {
      for(let i=0; i<this.terms.length; i++) {
        if(this.terms[i].now == true) {
          this.selectTerm = this.terms[i]
          break;
        }
      }
    },
    handleShowSelectTerm(term) {
      this.$axios.get("animes", { params: term })
        .then(res => this.animes = res.data)
        .catch(err => console.log(err.status));
      window.scrollTo({
        top: 0,
        behavior: "instant"
      });
    },
  }
}
</script>
