<template>
  <div>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <h2>今期アニメ</h2>
    <v-container class="grey lighten-5">
      <v-row>
        <v-col
          v-for="anime in animes"
          :key="anime.id"
          cols="sm"
        >
          <v-card
            class=""
            outlined
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
export default {
  name: "AnimeIndex",
  data() {
    return {
      animes: [],
      terms: [],
    }
  },
  computed: {
    nowYearSeason() {
      const date = new Date();
      const now_year = date.getFullYear()
      const now_season = (date.getMonth - 1) / 3 + 1
      const nowYearSeason = {
        year: now_year,
        season: now_season
      }
      return nowYearSeason
    },
  },
  created() {
    this.fetchAnimes();
    this.fetchTerms();
  },
  methods: {
    fetchAnimes() {
      //TODO: yearを数値として送っても、受け取る側で文字列になってしまう
      const nowYearSeason = this.nowYearSeason
      this.$axios.get("animes", { params: nowYearSeason })
        .then(res => this.animes = res.data)
        .catch(err => console.log(err.status));
    },
    fetchTerms() {
      this.$axios.get("terms")
        .then(res => this.terms = res.data)
        .catch(err => console.log(err.status));
    }
  }
}
</script>
