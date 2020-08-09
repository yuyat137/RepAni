<template>
  <div>
    <p>Anime</p>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
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
  </div>
</template>

<script>
export default {
  name: "AnimeIndex",
  data() {
    return {
      animes: [],
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
    }
  },
  created() {
    this.fetchAnimes();
  },
  methods: {
    fetchAnimes() {
      //TODO: yearを数値として送っても、受け取る側で文字列になってしまう
      const nowYearSeason = this.nowYearSeason
      this.$axios.get("animes", { params: nowYearSeason })
        .then(res => this.animes = res.data)
        .catch(err => console.log(err.status));
    }
  }
}
</script>
