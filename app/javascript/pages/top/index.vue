<template>
  <div>
    <v-container>
      <v-row>
        <v-col
          cols="6"
        >
          <img
            src="../../assets/undraw_replay.png"
            width="100%"
          >
        </v-col>
        <v-col
          cols="4"
        >
          <router-link
            :to="{ name: 'AnimeIndex' }"
          >
            <v-card
              class="headline d-flex align-center"
              color="#70bee6"
              height="25%"
              dark
            >
              <p class="mx-auto my-0">
                アニメを探す
              </p>
            </v-card>
          </router-link>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  name: "TopIndex",
}
</script>
