<template>
  <v-footer
    color="primary lighten-1"
    padless
    absolute
  >
    <v-row
      justify="center"
      no-gutters
    >
      <v-col
        class="primary lighten-2 py-4 text-center white--text"
        cols="12"
      >
        {{ new Date().getFullYear() }} — <strong>リプアニ</strong>
      </v-col>
    </v-row>
  </v-footer>
</template>

<script>
export default({
  name: 'TheFooter',
  data() {
    return {
    }
  },
})
</script>
