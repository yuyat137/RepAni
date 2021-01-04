<template>
  <div>
    <v-container class="grey lighten-5">
      <v-row>
        <v-card
          :id="'term_' + term.id"
          class="rounded-lg mt-3 mx-auto"
          v-for="term in terms"
          :key="term.id"
          outlined
          @click="handleSelectTerm(term)"
          :color="term.id == selectTerm.id ? 'indigo lighten-4' : ''"
        >
          <v-list-item>
            <v-list-item-content>
              <v-list-item-title class="headline mb-1">
                {{ term.year }}年{{ term.season_ja }}アニメ
              </v-list-item-title>
            </v-list-item-content>
            <v-card-actions />
          </v-list-item>
        </v-card>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  name: "TermList",
  data() {
    return {
      selectTerm: ""
    }
  },
  props: {
    terms: {
      type: Array,
      required: true
    },
  },
  methods: {
    handleSelectTerm(term) {
      this.selectTerm = term
      this.$emit('select-term', term)
    }
  },
}
</script>
