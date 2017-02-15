---
title: fabgrid
layout: page
---

<div class="row">
	<div class="col-md-8">
		<p><strong>Low-voltage DC power grid to supply today's devices with power at the voltage they need.</strong></p>
		<p>One or a few central power supply units provide 5V, 12V, and 24V which are made available throughout the entire faciliy via surface-mounted wiring. Different types of outlets can provide any other (low) DC voltage and some extra features like monitoring, protection, or regulation.</p>
		<h2>Why fabgrid?</h2>
		<blockquote>When all outlets are occupied with power adapters, aren't we just using the wrong power grid?</blockquote>
		<p>Many devices that we use daily need a power adapter in order to operate on AC current at 110 or 230 V, as typically provided by the outlets installed in our houses. This project is meant to develop a system for creating a paralell, low-voltage DC-power grid with respect to the requirements and capabilities of a fablab. Yet, the system is intended to be used in homes and other professional enviroments equally.</p>
	</div>
	<div class="col-md-4">
		<img src="{{ site.baseurl }}/assets/img/fabgrid-logo-dark.png" class="img-fluid">
	</div>
</div>

---

## Structure

### CPU (Central Power Unit)
### Grid
#### Distribution grid (flush- or wall-mounted)
#### Access grid (wall-mounted)
### Outlets
### Monitoring

## Challenges

- Find the right tradeoff between price and power dissipation when calculating the cross section of the copper required for the grid
- Protect connected devices from other devices accidentially causing power spikes
- Ensure a smooth and stable DC signal
- Make it easy to install

## Roadmap

1. Specification (Distances, voltages, max currents)
2. Electrical Design
	- Rough schematic of the entire system
	- Schematic for a basic outlet
3. Mechanical Design
	- Conductor
		- Geometry
		- Joints
		- Wall mounts
	- Outlets
		- Electric joints
		- Case

## About

- Me: [https://jsph.pl/about-joseph-paul/](https://jsph.pl/about-joseph-paul/)
- The lab: [http://www.erfindergarden.de/](http://www.erfindergarden.de/)
- FabAcademy: [http://fabacademy.org/](http://fabacademy.org/)