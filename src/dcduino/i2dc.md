---
title: I²DC
layout: page
---

I²DC is an ATTiny-enhanced N-Channel MOSFET with a series inductance and current sensing shunt. Output voltage and current can be read and set through I²C.

## Features

- 72W N-Channel MOSFET
- ATTiny85
- Voltage dividers for voltage sensing
- Shunts for current sensing
- I²C interface

## Specs

- Ptotal = 72W
- Vin = 6…36V
- Vout = 8…Vin
- Iout: 5A

## Hardware Design

In essence, the hardware consists of the following parts:

- Switch (MOSFET)
- Low pass filter (Coil + Cap)
- Current sensing circuit (Shunt + opamp)
- Voltage sensing circuit (Voltage divider)
- I²C interface (ATTiny)

### Switch Choice

The choice of an N-Channel MOSFET is quite straight forward. We just pick it from the Fab inventory ([RFD16N05LSM Datasheet](https://www.fairchildsemi.com/datasheets/RF/RFD16N05LSM.pdf)).

But … we need to consider how to drive it. In other designs i've seen the gate driven from a 5V µC through a 100Ω resistor, with a 1kΩ pull-down to ground, so let's just copy that. The gate on a MOSFET has high capacitance and super high resistance to source, so can use low value resistor to drive it strongly without it drawing any significant current.

The pull-down is there to quickly turn the gate off when the PWM'ed pin on the µC goes low. Also, it prevents the gate from floating freely. A floating gate would lead to unpredicatble switching activity while the µC is off (or in case it fails), which could damage the connected load.

> MOSFET circuit

### Output Filter Design

As we don't want to add any resistance to the drain path, a typical RC design won't work so we're left with coils for the low-pass filter. The entire filter involves an inductor (coil), a capacitor, and a flyback diode. Roughly speaking, the coil is there to filter out the high PWM frequencies, the capacitor feeds the load during MOSFET's "off" phases, and the flyback diode allows the coil to discharge at the same time.

Higher switching frequencies allow us to use smaller coils and capacitors. The maximum native PWM frequency we can bang out of that little ATTiny85 is **62.5kHz**. Let's [simulate](http://www.falstad.com/circuit/) that with an 8Ω load (3A @ 24V):

> Video

Dont ask me how i found those values, but a **33µH inductor** and a **220µF capacitor** seem to provide a smooth enough DC. The settle duration, when changing the duty cycle/voltage is of minor importance for now, we can tweak that later…

The flyback diode must be able to handle the same current that flows through our inductor. And that's the same as our maximum current rating, 5 amps. As there will be no continuous load on the diode, only pulses, i think it's fine to choose a diode rated at 5A (continuously) without any additional safety margin. In a ["synchrounous"](https://en.wikipedia.org/wiki/Buck_converter#Synchronous_rectification) design, the flyback diode would be replaced by a secondary switch, which would be turned "on" during the "off" phase of the main switch, effectively cutting down losses.

So these are the parts for the low-pass filter:

| Purpose  | Part Number | Specs |
|----------|-------------|----------------|
| Coil     | [SRP1265A-330M](http://www.bourns.com/docs/Product-Datasheets/SRP1265A.pdf) |  33uH 8A 58mΩ SMD |
| Capacitor| [UCW1H221MNL1GS](http://datasheet.octopart.com/UCW1H221MNL1GS-Nichicon-datasheet-81472606.pdf) | 220uF 50V 20% (10 X 10mm) SMD 670mA 7000h 105°C T/R |
| Diode    | [PDU620-13](http://datasheet.octopart.com/PDU620-13-Diodes-Inc.-datasheet-8398636.pdf) |  200V 6A Surface Mount Ultra-Fast Recovery Rectifier - PowerDI-5 |

### Current Sensing

For current sensig we're gonna use a very small series resistor with an accurately known value. The voltage drop accross this resistor can be measured and converted into a current using the known resistance.

But now comes the problem: our spcifications say we want to support a maximum current of up to 5A. So if we want to convert 5 amps into the maximum sensing range of out ATTiny – let's assume we're running at 5V, so 5V – we'd need a 1Ω resistor. One ohm, thats way too much voltage drop and power dissipation. So what's the solution? An opamp, right! It lets us use a way smaller resistor, say 10mΩ, and "amplifies" the voltage drop into the full range of our µC.

And by the way, as we're using an op-amp already, let's sense the current on the high side. This comes for free as a side-effect of using an op-amp and is more reliable because it also covers current drawn through alternative ground paths on the load, that we're not in control of.

Okay let's use a special op-amp that's made for exactly our job, the [INA169](http://www.ti.com/lit/ds/symlink/ina139.pdf). It's also used in a [sparkfun breakout board](https://www.sparkfun.com/products/12040), for which they provide the [schematics](Schematic) and [further documentation](https://learn.sparkfun.com/tutorials/ina169-breakout-board-hookup-guide). By the way, Sparkfun, Adafruit et al. are good resources for finding example applications of some common ICs and other components…

#### Shunt Resistor

What's gonna be the value of the shunt? According to its datasheet, the INA169 operates best if the upper input voltage is between 50 and 100mV. Let's choose the lower bound because it's gonna cut down losses and will surely yield a nice 1e^x resistor value with our 5A spec:

<math>
	<mi>R</mi>
	<mo>=</mo>
	<mfrac>
		<mrow><mn>50</mn><mi>mV</mi></mrow>
		<mrow><mn>5</mn><mi>A</mi></mrow>
	</mfrac>

	<mo>=</mo>
	<mn>10</mn><mi>mΩ</mi>
</math>

What power is it gonna turn into heat?

<math>
<mi>P</mi> <mo>=</mo> <msup><mi>I</mi><mn>2</mn></msup> <mo>×</mo> <mi>R</mi>
<mo>=</mo> <mn>25</mn><msup><mi>A</mi><mn>2</mn></msup> <mo>×</mo> <mn>0.010</mn><mo>Ω</mo>
<mo>=</mo> <mfrac><mn>1</mn><mn>4</mn></mfrac><mi>W</mi>
</math>

So for some safety margin we should probably go with a <math><mo>≥</mo><mfrac><mn>1</mn><mn>2</mn></mfrac><mi>W</mi></math> resistor for the job…

#### Load Resistor

Sparkfun also tell us in their "hookup guide" how to calculate the values of the additional resistor. We need a seconday resistor at the output of the opamp, that converts the "known current" output into a "known voltage". The formula goes as follows:

<math>
	<msub><mi>I</mi><mi>s</mi></msub>
	<mo>=</mo>
	<mfrac>
		<mrow><msub><mi>V</mi><mi>out</mi></msub> <mo>×</mo> <mn>1</mn><mi>kΩ</mi></mrow>
		<mrow><msub><mi>R</mi><mi>s</mi></msub> <mo>×</mo> <msub><mi>R</mi><mi>l</mi></msub></mrow>
	</mfrac>
</math>

The value we're looking for is <math><msub><mi>R</mi><mi>l</mi></msub></math>. The value of the **s**hunt resistor is <math><msub><mi>R</mi><mi>s</mi></msub></math>. Tweaking the equation a bit, we get:

<math>
	<msub><mi>R</mi><mi>l</mi></msub>
	<mo>=</mo>
	<mfrac>
		<mrow><msub><mi>V</mi><mi>out</mi></msub> <mo>×</mo> <mn>1</mn><mi>kΩ</mi></mrow>
		<mrow><msub><mi>R</mi><mi>s</mi></msub> <mo>×</mo> <msub><mi>I</mi><mi>s</mi></msub></mrow>
	</mfrac>
</math>

Plugging in the value of the shunt and our values for the maximum current of 5A ≘ 5V:

<math>
	<msub><mi>R</mi><mi>l</mi></msub>
	<mo>=</mo>
	<mfrac>
		<mrow><mn>5</mn><mi>V</mi> <mo>×</mo> <mn>1</mn><mi>kΩ</mi></mrow>
		<mrow><mn>10</mn><mi>mΩ</mi> <mo>×</mo> <mn>5</mn><mi>A</mi></mrow>
	</mfrac>

	<mo>=</mo>
	<mfrac>
		<mrow><mn>1</mn><mi>kV</mi></mrow>
		<mrow><mn>10</mn><mi>mA</mi></mrow>
	</mfrac>

	<mo>=</mo>
	<mfrac>
		<mrow><mn>1</mn></mrow>
		<mrow><mn>0.010</mn></mrow>
	</mfrac>
	<mi>kΩ</mi>

	<mo>=</mo>
	<mn>100</mn>
	<mi>kΩ</mi>
</math>

#### Final Parts Choice

As always, I use the digikey search for its excellent filter options to find appropriate parts.

| Purpose | Part Number | Specs |
|---------|-------------|-------|
| Op-Amp | INA169 | 2.7 - 60V; 0.5%; SOT23-5 |
| Shunt (<math><msub><mi>R</mi><mi>s</mi></msub></math>) | [LVK12R010DER](http://www.ohmite.com/cat/res_lvk.pdf) | SMD 0.01 OHM 0.5% 1/2W 1206 |
| Load Resistor (<math><msub><mi>R</mi><mi>l</mi></msub></math>) | [RC1206FR-07100KL](http://www.yageo.com/documents/recent/PYu-RC_Group_51_RoHS_L_7.pdf) | (Fab Inventory) |

### Voltage Sensing


### I2C Interface

We need a pull-up on the SDA line. According to what i've read elsewhere, a 4.7k should be used. I see Neil use 10k ones in his examples, guessing that's because they're in the standard inventory. So anything in between 4.7k and 10k should be fine, assuming short wire lengths and low device count per bus.

http://academy.cba.mit.edu/classes/networking_communications/index.html
http://academy.cba.mit.edu/classes/networking_communications/I2C/hello.I2C.45.node.png

### Voltage Regulator

Besides all that, we need a small voltage regulator in order to power our microcontroller and opamp. This way we can use the board as a "programmable" step-down converter, where we set the parameters once (it should store them in EEPROM), and then operate it without any external control input.

#### How much current?

- The attiny itself takes less than 10mA when operating at 5V (8MHz)
- The INA169 says "Input current into any pin 10 mA MAX". Let's take it for that
- Our swiching pin will


## Further Lecture

- [https://en.wikipedia.org/wiki/Buck_converter](https://en.wikipedia.org/wiki/Buck_converter)
- [https://www.allaboutcircuits.com/textbook/alternating-current/chpt-8/low-pass-filters/](https://www.allaboutcircuits.com/textbook/alternating-current/chpt-8/low-pass-filters/)
- [https://www.allaboutcircuits.com/technical-articles/low-pass-filter-a-pwm-signal-into-an-analog-voltage/](https://www.allaboutcircuits.com/technical-articles/low-pass-filter-a-pwm-signal-into-an-analog-voltage/)
- [http://sim.okawa-denshi.jp/en/RLCtool.php](http://sim.okawa-denshi.jp/en/RLCtool.php)
- [http://www.electronics-tutorials.ws/filter/filter_2.html](http://www.electronics-tutorials.ws/filter/filter_2.html)
- [https://electronics.stackexchange.com/questions/165444/problem-with-simulating-lc-filter-with-n-channel-mosfet-used-for-pwm](https://electronics.stackexchange.com/questions/165444/problem-with-simulating-lc-filter-with-n-channel-mosfet-used-for-pwm)
- [http://www.learningaboutelectronics.com/Articles/Low-pass-filter.php](http://www.learningaboutelectronics.com/Articles/Low-pass-filter.php)
- [https://www.youtube.com/watch?v=6Otr1I0OR18#t=402.923392](https://www.youtube.com/watch?v=6Otr1I0OR18#t=402.923392)
- [https://www.seeedstudio.com/Adjustable-Step-Down-DC%26amp%3BDC-Converter-%280.8V-18V%26amp%3B3A%29-p-1716.html](https://www.seeedstudio.com/Adjustable-Step-Down-DC%26amp%3BDC-Converter-%280.8V-18V%26amp%3B3A%29-p-1716.html)
- [Choosing the optimum switching frequency of your DC/DC converter](http://www.eetimes.com/document.asp?doc_id=1272335)
- [Effects of High Switching Frequency on Buck Regulators](https://www.onsemi.com/pub/Collateral/TND388-D.PDF)
- [High-Side Current-Sense Measurement: Circuits and Principles](https://www.maximintegrated.com/en/app-notes/index.mvp/id/746)
