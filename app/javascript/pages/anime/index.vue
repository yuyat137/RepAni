<template>
  <div>
    <p>Anime</p>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <v-btn color="success">ボタンのラベル</v-btn>
  </div>
</template>

<script>
export default {
  name: "AnimeIndex",
}
</script>
