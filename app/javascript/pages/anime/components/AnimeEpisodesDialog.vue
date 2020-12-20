<template>
  <div :id="'anime-episodes-dialog-' + anime.id">
    <v-row justify="center">
      <v-dialog
        v-model="dialog"
        width="600px"
      >
        <v-card>
          <v-card-title>
            <span class="headline">
              {{ anime.title }}<br>
              サブタイトルを選んでください
            </span>
          </v-card-title>
          <v-card-text>
            <div
              v-for="episode in publicEpisodes"
              :key="episode.id"
            >
              <router-link :to="{ name: 'ReplayIndex', params: { episodeId: episode.id }}">
                {{ episode.num }}
              </router-link>
            </div>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-row>
  </div>
</template>
<script>
export default({
  name: 'AnimeEpisodesDialog',
  props: {
    anime: {
      required: true,
      type: Object,
    },
    episodes: {
      required: true,
      type: Array,
    },
  },
  data() {
    return {
      dialog: false,
    }
  },
  computed: {
    publicEpisodes() {
      return this.episodes.filter(episode => {
        return episode.public == true
      })
    },
  },
  methods: {
    open() {
      this.dialog = true;
    },
  }
})
</script>
