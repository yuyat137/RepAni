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
              src="../../assets/top7.png"
              width="100%"
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
          <a href="https://startup-technology.gyazo.com/93d6cd419fc22942f0fffd9d0bb01f04"><img src="https://t.gyazo.com/teams/startup-technology/93d6cd419fc22942f0fffd9d0bb01f04.gif" alt="Image from Gyazo" width="50%"/></a>
            <img
              src="../../assets/mac2.png"
              width="60%"
            >
          </div>
        </v-col>
      </v-row>
      <v-row>
        <v-col
          cols="4"
        >
          <img
            src="../../assets/audio_conversation.png"
            width="100%"
          >
          <p class="text-h6">皆の反応を見ながらアニメを楽しみたい</p>
        </v-col>
        <v-col
          cols="4"
        >
          <img
            src="../../assets/work_chat.png"
            width="100%"
          >
          <p class="text-h6">アニメ放送時のTwitterを再現</p>
        </v-col>
        <v-col
          cols="4"
        >
          <img
            src="../../assets/happy_announcement.png"
            width="100%"
          >
          <p class="text-h6">120%アニメを楽しむ</p>
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
