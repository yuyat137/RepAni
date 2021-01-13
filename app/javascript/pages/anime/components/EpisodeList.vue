<template>
  <div>
    <v-container>
      <v-simple-table>
        <template v-slot:default>
          <thead>
            <tr>
              <th class="text-left">
                エピソード
              </th>
            </tr>
          </thead>
          <tbody v-if="episodes.length" id="episodes_list">
            <tr
              v-for="episode in episodes"
              :key="episode.id"
              :id="'episode_' + episode.id"
              @click="goToReplayIndex(episode.id)"
            >
              <td>
                {{ episode.num }}話 『{{ episode.subtitle }}』
              </td>
            </tr>
          </tbody>
          <tbody v-else-if="anime != null">
            <tr>
              <td>エピソードはありません</td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-container>
  </div>
</template>

<script>
export default {
  name: "EpisodeList",
  props: {
    anime: {
      type: Object,
      required: true
    },
    episodes: {
      type: Array,
      required: true
    },
  },
  computed: {
    publicEpisodes () {
      return this.episodes.filter(episode => {
        return episode.public == true
      })
    },
  },
  methods: {
    goToReplayIndex(episodeId) {
      this.$router.push({ name: 'ReplayIndex', params: { episodeId: episodeId } });
    }
  }
}
</script>
