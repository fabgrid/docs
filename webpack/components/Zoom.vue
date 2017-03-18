<template>
	<img :src="src" :alt="alt" :title="title" :class="classes" @click="toggle" />
</template>


<script>
import Vue = require('vue')
import { Component } from 'av-ts'

// The @Component decorator indicates the class is a Vue component
@Component({
	props: ['src', 'alt', 'title'],
})
export default class Zoom extends Vue
{
	src: string
	alt: string
	title: string

	zoomed_in: boolean = false

	get classes(): Object {
		return {
			'img-zoom': true,
			'zoomed-in': this.zoomed_in,
			'constrain': !this.zoomed_in
		}
	}

	toggle(): void {
		this.zoomed_in = !this.zoomed_in
	}
}
</script>


<style lang="sass" scoped>
.img-zoom {

	cursor: pointer;

	&.zoomed-in {
		position: fixed;
		top: 0;
		left: 2.5%;
		z-index: 10000;
		width: 90%;
		height: auto;
		margin: 2.5%;
		transition: all .2s ease-out;

		&.shadow {
			box-shadow: 0 1vh 3vh #999;
		}
	}
}
</style>
