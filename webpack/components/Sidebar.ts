import Vue = require('vue')
import Component from 'vue-class-component'


// The @Component decorator indicates the class is a Vue component
@Component({})
export default class MyComponent extends Vue {

	menuOpen: boolean = false

	toggleMenu(): void {
		this.menuOpen = !this.menuOpen
	}

}