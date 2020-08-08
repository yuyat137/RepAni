<template>
  <v-app>
    <div style="position: relative; min-height: 100%;">
      <TheHeader />
      <router-view id="main" />
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
#main {
  padding-bottom: $footer-height;
}
</style>
