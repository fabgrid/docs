declare var Vue: any

var sidebar = new Vue({
	el: '#sidebar',

	data() {
		return {
			menuOpen: false
		}
	},

	methods: {
		toggleMenu() {
			this.menuOpen = !this.menuOpen
		}
	},

	created() {
		console.log('                                 ')
		console.log('   /) __,   /_  __   ,_   .  __/ ')
		console.log(' _//_(_/(__/_)_(_/__/ (__/__(_/(_')
		console.log('_/             _/_               ')
		console.log('/)            (/                 ')
		console.log('`                                ')
		console.log('    http://fabgrid.github.io     ')
	}
})
