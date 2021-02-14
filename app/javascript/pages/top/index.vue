<template>
  <div>
    <v-container>
      <v-row id="top">
        <v-col
          cols="4"
          offset=1
          id="description"
          class="d-flex flex-column justify-space-around"
        >
          <div class="text-center">
            <img
              src="../../assets/logo.png"
              width="80%"
            >
          </div>
          <div id="to_anime_lists">
            <router-link
              :to="{ name: 'AnimeIndex' }"
              class="text-decoration-none"
            >
              <v-card
                class="headline d-flex align-center mx-auto"
                color="#70bee6"
                width="70%"
                dark
              >
                <p class="py-3 mx-auto my-0">
                  アニメを探す
                </p>
              </v-card>
            </router-link>
          </div>
        </v-col>
        <v-col
          cols="7"
        >
          <div class="py-5 my-5">
          <img src="../../assets/top-image.gif" width="70%"/>
          </div>
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

<style scoped>
#top {
  height: 90vh;
}
#description {
 height: 70%;
}
#to_anime_list {
  height: 80%;
  width: 80%;
}

</style>
