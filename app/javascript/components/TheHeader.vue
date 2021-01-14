<template>
  <div>
    <v-app-bar
      color="primary"
      dark
    >
      <v-toolbar-title>
        <router-link
          :to="{ name: 'TopIndex' }"
          class="title-color headline"
        >
          リプアニ
        </router-link>
      </v-toolbar-title>
    </v-app-bar>
  </div>
</template>

<script>
export default({
  name: 'TheHeader',
  data() {
    return {
    }
  },
})
</script>

<style scoped>
.title-color {
  color: #f8f8ff;
}
</style>
