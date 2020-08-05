<template>
  <v-app>
    <div>
      <TheHeader />
      <router-view />
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
