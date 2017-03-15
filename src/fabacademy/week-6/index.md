---
title: 'W6: Electronics Design'
assignment: Redraw the echo hello-world board, add a button & LED
goal: Create a step-down and current sensing board
links: []

layout: lesson
previous: fabacademy/week-5/index.md
next: fabacademy/week-7/index.md
---

## Table of Contents

* TOC
{:toc}

---

Goal is to create a step-down converter board with current sensing and limiting functionality. It should be capable of providing 10A @ 5V from a 12V line.

We will use an ATTiny for voltage sensing and to control a MOSFET via PWM to produce the desired output voltage. Capacitors will be used to filter the output signal, which makes high PWM frequencies desirable in order to keep the caps small. A high-side current sensing circuit will be used to track and limit current.

## Schematic Design

### Software choice

I have prior experience with [Fritzing](http://fritzing.org/), which is quite easy to learn and to use and has many parts in its libraries. This time i will try [Eagle](http://www.autodesk.com/products/eagle/overview) as it's a de-facto standard and i want to learn to use it.

### Parts choice

- Processor: [Atmel ATTINY45](https://octopart.com/attiny45-20su-microchip-39667100)
- MOSFET: [Vishay SI7852DP](https://octopart.com/si7852dp-t1-e3-vishay+siliconix-999345)
- Current sensor: [Allegro ACS715](https://octopart.com/acs715llctr-20a-t-allegro+microsystems+llc-38945941)

The current sensor is a hall-effect based sensor providing a linear voltage that represents the current across its very low-impedance (1.2 mΩ) internal conductor.

Eagle footprints for the ACS712 are available in the [Sparkfun Libraries](https://github.com/sparkfun/SparkFun-Eagle-Libraries). For the PowerPAK (SO-8) package of the SI7852DP, i consulted [Bob Starr' Eagle libraries](https://github.com/robertstarr/lbr_user).

