<template>
  <div>
    <router-link :to="{ name: 'TopIndex' }">
      Topへ
    </router-link>
    <h2>ツイートのリプレイ</h2>
  </div>
</template>

<script>
export default {
  name: "ReplayIndex",
  data() {
    return {

    }
  },
}
