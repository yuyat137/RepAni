import Vue from 'vue'
import Router from 'vue-router'
import TopIndex from '../pages/top/index'
import AnimeIndex from '../pages/anime/index'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: TopIndex,
      name: 'TopIndex'
    },
    {
      // NOTE: Animeに関しては、ここだけ複数形でない(不自然なので)
      path: '/anime',
      component: AnimeIndex,
      name: 'AnimeIndex'
    }
  ],
})

export default router
