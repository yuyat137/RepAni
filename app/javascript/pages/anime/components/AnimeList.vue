<template>
  <div>
    <v-container>
      <v-simple-table>
        <template v-slot:default>
          <thead>
            <tr>
              <th class="text-left">
                アニメ
              </th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="anime in publicAnimes"
              :key="anime.id"
              @click="handleSelectAnime(anime)"
              :class="anime.id == selectAnime.id ? 'indigo lighten-4' : ''"
              :id="'anime_' + anime.id"
            >
              <td>{{ anime.title }}</td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-container>
  </div>
</template>

<script>
export default {
  name: "AnimeList",
  data() {
    return {
      selectAnime: ""
    }
  },
  props: {
    animes: {
      type: Array,
      required: true
    },
  },
  computed: {
    publicAnimes () {
      return this.animes.filter(anime => {
        return anime.public == true
      })
    },
  },
  methods: {
    handleSelectAnime(anime) {
      this.selectAnime = anime
      this.$emit('select-anime', anime)
    }
  },
}
</script>
