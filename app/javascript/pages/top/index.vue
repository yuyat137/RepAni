<template>
  <div>
    <p>リプアニ</p>
    <p>Top</p>
    <router-link :to="{ name: 'AnimeIndex' }" >Animeへ</router-link>
  </div>
</template>

<script>
export default {
  name: "TopIndex",
}
</script>

