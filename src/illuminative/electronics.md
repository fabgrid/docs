---
title: Electronics – IllumiNative
layout: page
---

# Requirements

- Total of 1500 - 2000 lumen of luminous flux
- Two-channel constant current PWM drive
- Bluetooth interface
- RTC (for sunlight tracking)

# PCB Material

The PCB for the driver circuit will be on a regular 2-sided Expoxy base material. The LED arrays themselves are going to be milled from copper-plated aluminium base material, allowing lots of thermal energy to transit.

# Parts Choice

## LEDs

- High CRi
- Binned so we can drive them in parallel (ideally)

Cold: http://www.nichia.co.jp/specification/products/led_spec/NSSWT02AT-V2-E(4368A)R8000%20R90.pdf
Warm: http://www.nichia.co.jp/specification/products/led_spec/NSSLT02AT-V2-E(4371A)R8000%20R90.pdf

## Drivers

- 2 channels
- 0-1A / 24V per channel
- Settable current

So as described below, a *voltage controlled current sink (VCCS)* will be used to drive the LEDs through an op-amp/mosfet combination. The op-amp is configured in a way that the current on the output matches the voltage on the input. This is achieved by connecting the output to GND via a known value resistor. If this resistor is 1Ω, the output current will be equal to 1A if the input voltage is 1V.

### Low pass filter

A 2-stage RC low-pass filter is between the µC and the opamp's input. I choose 2x (2kΩ and 1µF) in series, which gives quite a smooth DC @244Hz with 50% duty cycle. Another µF is added at the opamp's output. The simulation (link below) shows that our resulting output current remains a ripple of roughly ±10mA. I hope that's small enough to not be noticable on the LEDs.

### Voltage divider

As our target current range is 0-1A, we need a 1/5 voltage divider to convert our µC's 5V (@ 100% PWM duty cycle) signal to a 1V opamp input, which should yield a 1A constant output. Our filter already adds 4kΩ of series resistance. Adding another 5.9k in series and 2.49k to ground gives us the following divider ratio:

(4k+5.9k+2.49k) / 2.49k = 4.9759036145

That's close enough to our 1/5 target ratio, as we don't need an exactly know current. We only need to know the maximum current fairly exactly and need to control it linearly.

## Bluetooth Adapter

## Microcontroller

### Requirements

- Serial interface (for bluetooth adapter)
- 2 hi-res PWM channels
- Something to interface with the RTC
- 2 interrupts to read the rotary encoder
- Another interrupt for the encoder push button

[328P Datasheet](http://www.atmel.com/images/Atmel-8271-8-bit-AVR-Microcontroller-ATmega48A-48PA-88A-88PA-168A-168PA-328-328P_datasheet_Complete.pdf)

The two external interrupts available on the 328 will take care of the rotary encoder. A pin change interrupt will monitor its push button.

A serial bluetooth module will interface with the hardware serial port.

### Pin mapping

| Pin Name | Pin # | Function       |
|----------|------:|----------------|
| PB1      |    13 | LED cold     |
| PB2      |    14 | LED warm     |
| PD0      |    30 | BT Rx        |
| PD1      |    31 | BT Tx        |
| PD2      |    32 | Encoder -    |
| PD3      |     1 | Encoder +    |
| PD4      |     2 | Encoder push |

### Brightness steps

The problem with our standard 8-bit PWM is that those steps are linearly spaced. 256 steps would be enough for our eye to notice no discrete steps, if only they were spaced logarithmically. Our eye's perception of brightness is approximately logarithmic. This means doubling the perceived brightness requires four times the light. So at the lower end of the duty cycle, we're gonna have too big increments in order to dim without noticable steps, while at the upper end the increments could be way bigger without us noticing any jumps in brightness.

So what's the solution? Logarithmic PWM, right? No idea if that exists – i've never heard of it. Instead, we can increase the resolution of our PWM to a lot more steps, and then choose a tiny subset of logarithmically-spaced duty cycle values. Assuming our LEDs have a near-linear power-to-brighness curve, looping through that subset should give us almost linear dimming.

These lookup tables for different bit depths, created by the fine guys at mikrocontroller.net forum, should illustrate what i'm saying:

```c
const uint16_t pwmtable_8D[32] PROGMEM =
{
    0, 1, 2, 2, 2, 3, 3, 4, 5, 6, 7, 8, 10, 11, 13, 16, 19, 23,
    27, 32, 38, 45, 54, 64, 76, 91, 108, 128, 152, 181, 215, 255
};

const uint16_t pwmtable_10[64] PROGMEM =
{
    0, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10,
    11, 12, 13, 15, 17, 19, 21, 23, 26, 29, 32, 36, 40, 44, 49, 55,
    61, 68, 76, 85, 94, 105, 117, 131, 146, 162, 181, 202, 225, 250,
    279, 311, 346, 386, 430, 479, 534, 595, 663, 739, 824, 918, 1023
};

const uint16_t pwmtable_16[256] PROGMEM =
{
    0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3,
    3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7,
    7, 7, 8, 8, 8, 9, 9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15,
    15, 16, 17, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    31, 32, 33, 35, 36, 38, 40, 41, 43, 45, 47, 49, 52, 54, 56, 59,
    61, 64, 67, 70, 73, 76, 79, 83, 87, 91, 95, 99, 103, 108, 112,
    117, 123, 128, 134, 140, 146, 152, 159, 166, 173, 181, 189, 197,
    206, 215, 225, 235, 245, 256, 267, 279, 292, 304, 318, 332, 347,
    362, 378, 395, 412, 431, 450, 470, 490, 512, 535, 558, 583, 609,
    636, 664, 693, 724, 756, 790, 825, 861, 899, 939, 981, 1024, 1069,
    1117, 1166, 1218, 1272, 1328, 1387, 1448, 1512, 1579, 1649, 1722,
    1798, 1878, 1961, 2048, 2139, 2233, 2332, 2435, 2543, 2656, 2773,
    2896, 3025, 3158, 3298, 3444, 3597, 3756, 3922, 4096, 4277, 4467,
    4664, 4871, 5087, 5312, 5547, 5793, 6049, 6317, 6596, 6889, 7194,
    7512, 7845, 8192, 8555, 8933, 9329, 9742, 10173, 10624, 11094,
    11585, 12098, 12634, 13193, 13777, 14387, 15024, 15689, 16384,
    17109, 17867, 18658, 19484, 20346, 21247, 22188, 23170, 24196,
    25267, 26386, 27554, 28774, 30048, 31378, 32768, 34218, 35733,
    37315, 38967, 40693, 42494, 44376, 46340, 48392, 50534, 52772,
    55108, 57548, 60096, 62757, 65535
};
```

*Source: [mikrocontroller.net/articles/LED-Fading](https://www.mikrocontroller.net/articles/LED-Fading) (german language)*

#### Resolution vs. Clock frequency

Timer1 on the 328 has 16 bit and two output compare registers. We can use that to drive two PWM outputs with up to 16 bit resolution (0-65535). But – and here's the next issue – this would reduce out PWM *frequency* to <math><mfrac><mrow><mn>16</mn><mi>MHz</mi></mrow><mrow><msup><mn>2</mn><mn>16</mn></msup></mrow></mfrac><mo>≈</mo><mn>244</mn><mi>Hz</mi></math>. That would require huge filter components after the MOSFETs.

So we have to do some sort of trade-off between switching frequency and resolution. Also, increasing the clock frequency would help. We could run the Mega328 at 20MHz or even swap it for an XMega, which runs at 32MHz. If we don't want to fall below, say 2kHz switching frequency, with a 32MHz clock, the resolution would be <math><mfrac><mrow><mn>32</mn><mi>MHz</mi></mrow><mrow><mn>2</mn><mi>kHz</mi></mrow></mfrac><mo>=</mo><mn>16000</mn><mo>≈</mo><msup><mn>2</mn><mn>14</mn></msup></math>. 14 bit – let's go with that for the beginning…

##### Better solution:

I found a nice circuit called the *Voltage Controlled Current Sink*. It uses an opamp to generate a constant current through a ground resistor from a control voltage. The advantage is that there's no need to filter the high current signal after the MOSFET, but only the small control voltage. This lets me use a much smaller filter circuit between the µC and the opamp.

An [online simulator](http://www.falstad.com/circuit/) helps me validate the circuit before bulding it:

<a href="http://www.falstad.com/circuit/circuitjs.html?cct=$+1+0.000005+16.13108636308289+36+5+43%0Aa+208+176+336+176+1+24+-24+1000000+1.0030980213359555+1.0032232070914697%0Af+448+176+496+176+0+1.5+0.02%0Ag+496+336+496+384+0%0Ar+368+176+448+176+0+100%0Ar+368+272+448+272+0+1000%0Ac+352+176+352+272+0+0.000001+11.515477530072522%0Aw+336+176+352+176+0%0Aw+352+176+368+176+0%0Aw+352+272+368+272+0%0Aw+448+272+496+272+0%0Aw+496+272+496+192+0%0Ar+496+272+496+336+0+1%0Ar+496+80+496+160+0+1%0Aw+208+192+208+272+0%0Aw+208+272+352+272+0%0AR+496+80+496+48+0+0+40+24+0+0+0.5%0Ag+-176+272+-176+336+0%0Ac+-176+160+-176+272+0+0.000001+4.19419822723698%0Ar+-176+160+-240+160+0+2000%0AR+-240+160+-272+160+0+2+244+2.5+2.5+0+1%0Ap+208+160+208+64+1+0%0Ar+-96+160+-16+160+0+2000%0Ar+-176+160+-96+160+0+2000%0Ac+-96+160+-96+272+0+0.000001+3.3883964544733853%0Ag+-96+272+-96+336+0%0Ac+-16+160+-16+272+0+0.000001+2.5825946817093755%0Ag+-16+272+-16+336+0%0Aw+-16+160+48+160+0%0Ag+128+272+128+336+0%0Aw+128+160+208+160+0%0Ar+48+160+128+160+0+3920%0Ar+128+160+128+272+0+2490%0Ao+12+16+0+4099+1.25+1.6+0+2+12+3%0Ao+20+16+0+4098+1.25+0.1+1+1%0A"><img src="circuit-simulator.png" />

# PCB Design

Again, i choose [Upverter](https://upverter.com/) for the electronics design and layout process. I like the globally shared parts library and the ease of creating new ones.

## VCCS module

First, i create the VCCS including input filter and driver MOSFET as a separate module. This makes it easier to maintain and update that sub-circuit, whithout applying each change in two separate places. Plus, it keeps the final board schematic much tidier, by treating that section the same as an IC with a single symbol.

> Link to VCCS module

## General Process

The general process goes as follows:

### Schematic

First step is always to design the schematic, which defines the desired relationships between the components in electrical terms.

1. **RTFM** for each critical part ("Typical Application" often gives a quick overview over the required external components)
2. **Place symbols**
3. **Draw connections** between components
4. **Use flags** if too many connections would cross
5. **Check** that all required connections are established, and that there are no unintended ones

<div class="alert alert-warning">
    <strong>Note:</strong> Many active components need a decoupling capacitor close to their VCC, in order to provide them with enough current on occasional load spikes, and to keep noise they generate from affecting other components on the same line. <em>You should never spare them!</em> Otherwise, you might get unpredictable behaviour and time-consuming errors later on…
</div>

### Layout

#### Parts Placement

When the first version of the schematic is complete, i move over to the board layout. Upverter typically puts all components from the schematic in a straight horizontal line. Pins that need an electrical connection according to the schematic are connected by thin green lines. I rearrange them so that those green lines become short and don't cross.

Usually, i place large (& high pin count) components first, and arrange the small ones (& low pin count) around them.

<div class="alert alert-info">
    <strong>Hint:</strong> When placing components close to each other, keep in mind your soldering process. Hand soldering requires quite some extra clearance so you can access all pins with the soldering iron, without frying any other parts.
</div>

#### Traces

As soon as all components have been arranged, i start to draw the traces. Before that, i set up a *clearace constraint* in the software to ensure that no pads or traces are closer together than the tool is capable to separate. Usually, i choose a minimum trace clearance of .3mm, to ensure the Othermill can work it with a 1/100" end mill, at least. In case i underrun that constraint while lying out the traces, Upverter would create a warning and highlight the affected areas in red.

For standard signal and low current power lines, i use the default .508mm trace width set in Upverter. For higher current lines (~1A and above), i use an [online calculator](http://circuitcalculator.com/wordpress/2006/01/31/pcb-trace-width-calculator/) to determine the appropriate trace width for given current rating and trace length. The 35mil copper layer on most standard PCB materials equals a weigth of <math><mn>1</mn><mfrac><mi>oz</mi><msup><mi>ft</mi><mn>2</mn></msup></mfrac></math>.

