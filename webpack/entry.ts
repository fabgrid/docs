import Vue = require('vue')
import Sidebar from './components/Sidebar'

var app = new Vue({

	delimiters: ['${', '}'],

	created() {
		console.log('                                 ')
		console.log('   /) __,   /_  __   ,_   .  __/ ')
		console.log(' _//_(_/(__/_)_(_/__/ (__/__(_/(_')
		console.log('_/             _/_               ')
		console.log('/)            (/                 ')
		console.log('`                                ')
		console.log('    http://fabgrid.github.io     ')
	},

	components: {
		Sidebar
	},

}).$mount('#app')
