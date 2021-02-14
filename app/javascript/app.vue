<template>
  <v-app>
    <div id="app">
      <TheHeader />
      <router-view id="router_view" />
      <TheFooter />
    </div>
  </v-app>
</template>

<script>
import TheHeader from './components/TheHeader'
import TheFooter from './components/TheFooter'

export default {
  components: {
    TheHeader,
    TheFooter
  }
}
</script>
<style lang="scss">
@import "./css/_dimensions.scss";
#router_view {
  padding-bottom: $footer-height;
}

#app {
  position: relative;
  min-height: 100%;
  background-color: #f6f7f8;
}
</style>
