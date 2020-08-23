<template>
  <div :id="'anime-episodes-dialog-' + anime.id">
    <v-row justify="center">
      <v-dialog v-model="dialog" width="600px">
        <v-card>
          <v-card-title>
            <span class="headline">
              {{ anime.title }}<br>
              サブタイトルを選んでください
            </span>
          </v-card-title>
          <v-card-text>
            <div
              v-for="episode in episodes"
              :key="episode.id"
            >
              {{ episode.num }}
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
  data() {
    return {
      dialog: false,
    }
  },
  props: {
    anime: {
      required: true,
    },
    episodes: {
      required: true,
    },
  },
  methods: {
    open() {
      this.dialog = true;
    },
  }
})
</script>
