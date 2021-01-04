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
              :class="changeColor(anime)"
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
  props: {
    selectAnime: {
      type: Object,
      required: true
    },
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
      this.$emit('select-anime', anime)
    },
    changeColor(anime) {
      // selectAnimeを親から受け取ってるのは、放送時期を変えた時にリセットするため
      if (this.selectAnime && this.selectAnime.id == anime.id) {
        return 'indigo lighten-4'
      }
    },
  },
}
</script>
