<template>
  <div>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <h2>{{ selectTerm.year }}年{{ selectTerm.season_ja }}</h2>
    <v-container class="grey lighten-5">
      <v-row>
        <v-col
          v-for="anime in animes"
          :key="anime.id"
          cols="4"
        >
          <v-card
            class=""
            outlined
            @click="handleStartTweetReplay(anime)"
          >
            <v-list-item three-line>
              <v-list-item-content>
                <div class="overline mb-4">
                  OVERLINE
                </div>
                <v-list-item-title class="headline mb-1">
                  {{ anime.title }}
                </v-list-item-title>
              </v-list-item-content>
              <v-card-actions />
            </v-list-item>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
    <h2>シーズン一覧</h2>
    <v-container class="grey lighten-5">
      <v-row>
        <v-col
          v-for="term in terms"
          :key="term.id"
          cols="3"
        >
          <v-card
            class="rounded-xl"
            outlined
            @click="handleShowSelectTerm(term)"
          >
            <v-list-item three-line>
              <v-list-item-content>
                <v-list-item-title class="headline mb-1">
                  {{ term.year }}年{{ term.season_ja }}アニメ
                </v-list-item-title>
              </v-list-item-content>
              <v-card-actions />
            </v-list-item>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
/* import Mixin from '../../packs/mixins/mixin' */

export default {
  name: "AnimeIndex",
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
