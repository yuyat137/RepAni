<template>
  <div>
    <p>Anime</p>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <div v-for="anime in animes">
      <span>{{ anime.title }}</span>
    </div>
  </div>
</template>

<script>
export default {
  name: "AnimeIndex",
  data() {
    return {
      animes: []
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
