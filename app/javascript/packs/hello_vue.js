import Vue from 'vue'
import App from '../app.vue'
import router from '../router/index.js'
import axios from '../plugins/axios'
import vuetify from '../plugins/vuetify'
import VueAnalytics from 'vue-analytics';

Vue.prototype.$axios = axios

Vue.use(VueAnalytics, {
  id: 'UA-189982098-1',
  router
});

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    vuetify,
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)
})
