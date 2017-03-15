import Vue = require('vue')
import { Component } from 'av-ts'


// The @Component decorator indicates the class is a Vue component
@Component({})
export default class Sidebar extends Vue {

	menuOpen: boolean = false

	toggleMenu(): void {
		this.menuOpen = !this.menuOpen
	}

}