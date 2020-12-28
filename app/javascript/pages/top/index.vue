<template>
  <div>
    <v-container>
      <v-row>
        <v-col
          cols="6"
        >
          <img src="../../assets/undraw_replay.png" width="100%" />
        </v-col>
        <v-col
          cols="4"
        >
          <router-link
            :to="{ name: 'AnimeIndex' }"
          >
            <v-card
              height='20%'
              class='headline my-5 d-flex align-center'
              color="#70bee6"
              dark
            >
              <p class="mx-auto my-0">
                放送時期から探す
              </p>
            </v-card>
          </router-link>
          <v-card
            height='20%'
            class='headline my-5 d-flex align-center'
            color="#0174DF"
            dark
          >
            <p class="mx-auto my-0">
              未実装
            </p>
          </v-card>
          <v-card
            height='20%'
            class='headline my-5 d-flex align-center'
            color="#52cc7a"
            dark
          >
            <p class="mx-auto my-0">
              未実装
            </p>
          </v-card>
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
