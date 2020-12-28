<template>
  <div>
    <v-container class="grey lighten-5">
      <v-row>
        <v-col
          v-for="anime in publicAnimes"
          :key="anime.id"
          cols="4"
        >
          <v-card
            :id="'anime_' + anime.id"
            class=""
            outlined
            @click="handleSelectAnime(anime)"
          >
            <v-list-item three-line>
              <v-list-item-content>
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
  name: "AnimeList",
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
      this.$emit('select-anime', anime)
    }
  },
}
</script>
