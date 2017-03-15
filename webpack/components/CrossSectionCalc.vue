<template>
	<div class="cross-section-calc">
		<div class="row">
			<div class="col-sm-6 calc-input">
				<div class="form-group row">
					<label for="voltage" class="col-sm-3 col-form-label">Voltage</label>
					<div class="col-sm-9 input-group">
						<input
							v-model="voltage"
							type="number"
							min="0"
							step="0.1"
							name="voltage"
							class="form-control"
						>
						<div class="input-group-addon"><math><mi>V</mi></math></div>
					</div>
				</div>
				<div class="form-group row">
					<label for="power" class="col-sm-3 col-form-label">Max. Power</label>
					<div class="col-sm-9 input-group">
						<input
							v-model="power"
							type="number"
							min="0"
							step="1"
							name="power"
							class="form-control"
						>
						<div class="input-group-addon"><math><mi>W</mi></math></div>
					</div>
				</div>
				<div class="form-group row">
					<label for="resistivity" class="col-sm-3 col-form-label">Resistivity</label>
					<div class="col-sm-9 input-group">
						<input
							v-model="resistivity"
							type="number"
							min="0"
							step="0.0001"
							name="resistivity"
							class="form-control"
						>
						<div class="input-group-addon"><math><mfrac><mrow><mi>Ω</mi><mo>×</mo><msup><mi>mm</mi><mn>2</mn></msup></mrow><mrow><mi>m</mi></mrow></mfrac></math></div>
					</div>
				</div>
				<div class="form-group row">
					<label for="target_dissipation" class="col-sm-3 col-form-label">Target</label>
					<div class="col-sm-9 input-group">
						<input
							v-model="target_dissipation"
							type="number"
							min="0"
							step="0.1"
							name="target_dissipation"
							class="form-control"
						>
						<div class="input-group-addon"><math><mfrac><mi>W</mi><mi>m</mi></mfrac></math></div>
					</div>
				</div>
			</div>
			<div class="col-sm-6 calc-output">
				<h4>Results:</h4>

				<h5>Current</h5>
				<script type="math/mml">
					<math display="block">
						<mn>{{ current | fixed }}</mn>
						&nbsp;
						<mi>A</mi>
					</math>
				</script>

				<h5>Load Resistance</h5>
				<script type="math/mml">
					<math display="block">
						<mrow>
							<mn>{{ load_resistance | fixed }}</mn>
							&nbsp;
							<mi>Ω</mi>
						</mrow>
					</math>
				</script>

				<h5>Target Conductor Resistance</h5>
				<script type="math/mml">
					<math display="block">
						<mrow>
							<mn>{{ target_resistance_m }}</mn>
							&nbsp;
							<mfrac>
								<mi>Ω</mi>
								<mi>m</mi>
							</mfrac>
						</mrow>
					</math>
				</script>

				<h5>Target Voltage Drop</h5>
				<script type="math/mml">
					<math display="block">
						<mrow>
							<mn>{{ target_voltage_drop_m | fixed }}</mn>
							&nbsp;
							<mfrac>
								<mi>V</mi>
								<mi>m</mi>
							</mfrac>
						</mrow>
					</math>
				</script>
			</div>
			<div class="col-sm-6">
				<pre>{{ $data }}</pre>
			</div>
		</div>
	</div>
</template>


<script>
import Vue = require('vue')
import { debounce } from 'throttle-debounce'
import { Component, Lifecycle, Watch } from 'av-ts'

declare var MathJax: any

// The @Component decorator indicates the class is a Vue component
@Component({
	filters: {
		fixed: (input) => {
			return Number(input).toFixed(2)
		}
	}
})
export default class CrossSectionCalc extends Vue {

	voltage: number = 24 // volt
	power: number = 1000 // watt
	resistivity: number = .0178 // copper
	target_dissipation: number = 1  // watt/meter

	refresher = debounce(270, false, function() {
		MathJax.Hub.Queue(["Reprocess", MathJax.Hub]);
	})

	get current(): number {
		return this.power/this.voltage
	}

	get load_resistance(): number {
		return this.voltage/this.current
	}

	get target_resistance_m(): number {
		let power_share: number = this.target_dissipation/this.power
		return this.load_resistance*power_share
	}

	get target_voltage_drop_m(): number {
		let total_resistance: number = this.load_resistance + this.target_resistance_m
		return (this.voltage/total_resistance)*this.target_resistance_m
	}

	@Watch('current')
	@Watch('target_resistance_m')
	refreshJax(): void {
		this.refresher()
	}

}
</script>


<style lang="sass" scoped>
	.calc-output {
		border: 1px solid #ffc107;
		background-color: #efefef;
		padding: 0 1em 0.5em;

		h4:before,
		h5:before {
			content: none;
		}
	}
</style>
