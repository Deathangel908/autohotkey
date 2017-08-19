// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './components/App.vue'
import './assets/stylesheets/main.sass'

Vue.config.productionTip = false;

/* eslint-disable no-new */
window.app = new Vue({
  el: '#contentstart',
  render: h => h(App),
});
