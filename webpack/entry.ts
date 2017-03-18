import Vue = require('vue')

import Sidebar from './components/Sidebar'
import Zoom from './components/Zoom'
import CrossSectionCalc from './components/CrossSectionCalc'

var app = new Vue({

	delimiters: ['${', '}'],

	created() {
		console.log('                                 ')
		console.log('   /) __,   /_  __   ,_   .  __/ ')
		console.log(' _//_(_/(__/_)_(_/__/ (__/__(_/(_')
		console.log('_/             _/_               ')
		console.log('/)            (/                 ')
		console.log('`                                ')
		console.log('   http://bit.ly/fab17-joseph    ')
	},

	components: {
		'sidebar': Sidebar,
		'zoom': Zoom,
		'cross-section-calc': CrossSectionCalc,
	},

}).$mount('#app')
