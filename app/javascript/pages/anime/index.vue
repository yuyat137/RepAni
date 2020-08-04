<template>
  <div>
    <p>Anime</p>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
  </div>
</template>

<script>
export default {
  name: "AnimeIndex",
}
</script>
