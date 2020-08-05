<template>
  <v-app>
    <div>
      <TheHeader />
      <router-view />
    </div>
  </v-app>
</template>

<script>
import TheHeader from './components/TheHeader'

export default {
  components: {
    TheHeader,
  }
}
</script>
