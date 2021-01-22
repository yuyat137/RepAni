<template>
  <div>
    <v-container>
      <v-breadcrumbs :items="items">
        <template v-slot:item="{ item }">
          <v-breadcrumbs-item
            :to="item.to"
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
            :select-term="selectTerm"
            @select-term="handleShowSelectTerm"
          />
        </v-col>
        <v-col cols="5">
          <h2>アニメ</h2>
          <AnimeList
            :animes="animes"
            :select-anime="selectAnime"
            @select-anime="handleShowAnimeEpisodesDialog"
          />
        </v-col>
        <v-col cols="4">
          <h2>エピソード</h2>
          <EpisodeList
            :anime="selectAnime"
            :episodes="episodes"
          />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import AnimeList from './components/AnimeList'
import TermList from './components/TermList'
import EpisodeList from './components/EpisodeList'

export default {
  name: "AnimeIndex",
  components: {
    AnimeList,
    TermList,
    EpisodeList,
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
          to: '/',
        },
        {
          text: '放送時期',
          to: '',
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
      this.episodes = [];
      this.selectAnime = null;
      this.selectTerm = term;
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
