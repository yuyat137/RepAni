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
            </span>
          </v-card-title>
          <v-card-text>
            <div
              v-for="episode in publicEpisodes"
              :key="episode.id"
            >
              <a @click="toOtherEpisode(episode)">
                {{ episode.num }}話 {{ displayTitle(episode) }}
              </a>
            </div>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-row>
  </div>
</template>
<script>
export default({
  name: 'EpisodesDialog',
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
      this.dialog = false
    },
  },
  methods: {
    open() {
      this.dialog = true;
    },
    displayTitle(episode) {
      return '「' + episode.subtitle + '」'
    },
    toOtherEpisode(episode) {
      this.dialog = false
      this.$router.push({ name: 'ReplayIndex', params: { episodeId: episode.id }})
    },
  }
})
</script>
