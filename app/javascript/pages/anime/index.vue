<template>
  <div>
    <p>Anime</p>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <v-container
      v-for="align in alignments"
      :key="align"
      class="grey lighten-5"
    >
      <v-row :align="align">
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
                <div class="overline mb-4">OVERLINE</div>
                <v-list-item-title class="headline mb-1">
                  {{ anime.title }}
                </v-list-item-title>
              </v-list-item-content>
              <v-card-actions>
              </v-card-actions>
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
      alignments: [
        'start',
        'center',
        'end',
      ],
    }
  },
  created() {
    this.fetchAnimes();
  },
  methods: {
    fetchAnimes() {
      this.$axios.get("animes")
        .then(res => this.animes = res.data)
        .catch(err => console.log(err.status));
    }
  }
}
</script>
