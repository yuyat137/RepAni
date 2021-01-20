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
          <div id="to_anime_list">
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
#to_anime_list {
  margin-top: 200px;
  height: 80%;
}
</style>
