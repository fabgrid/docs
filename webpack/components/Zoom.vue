<template>
	<div class="img-zoom" @click="toggle" :class="{'zoomed': zoomed_in}">
		<img :src="src" :alt="alt" :title="title" :class="classes" />
		<span v-if="has_caption" v-html="caption" class="img-caption"></span>

		<div v-if="zoomed_in" class="overlay">
			<div class="image" :style="{'background-image': 'url(' + src + ')'}"></div>
			<span v-if="has_caption" v-html="caption" class="img-caption"></span>
		</div>
	</div>
</template>


<script>
import Vue = require('vue')
import { Component } from 'av-ts'

// The @Component decorator indicates the class is a Vue component
@Component({
	props: ['src', 'alt', 'title', 'caption', 'shadow'],
})
export default class Zoom extends Vue
{
	src: string
	alt: string
	title: string
	caption: string
	shadow: boolean

	zoomed_in: boolean = false

	get classes(): Object {
		return {
			'constrain': true,
			'shadow': this.shadow
		}
	}

	get has_caption(): boolean {
		return this.caption && (this.caption.length > 0)
	}

	toggle(): void {
		this.zoomed_in = !this.zoomed_in
	}
}
</script>


<style lang="sass" scoped>
.img-zoom {
	cursor: zoom-in;
	margin-bottom: 2rem;

	&.zoomed {

		cursor: zoom-out;

	}

	.overlay {
		z-index: 1000;
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: rgba(100, 100, 100, 0.6);

		.image {
			width: 94vw;
			height: 90vh;
			margin: 5vh 3vw;
			background-size: contain;
			background-position: 50% 50%;
			background-repeat: no-repeat;
		}

		.img-caption {
			position: relative;
			padding: 1rem;
			bottom: 10vh;
			background-color: rgba(100, 100, 100, 0.9);
			color: #fff;
		}
	}
}
</style>
