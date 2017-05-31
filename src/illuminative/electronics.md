---
title: Electronics – IllumiNative
layout: page
---

# Requirements

- Total of 1500 - 2000 lumen of luminous flux
- Two-channel PWM drive
- Current monitor per channel
- Bluetooth interface

# PCB Material

The PCB for the driver circuit will be on a regular 2-sided Expoxy base material. The LED arrays themselves are going to be milled from aluminium base material, allowing lots of thermal energy to transit.

# Parts Choice

## LEDs

- High CRi
- Binned so we can drive them in parallel (ideally)

Cold: http://www.nichia.co.jp/specification/products/led_spec/NSSWT02AT-V2-E(4368A)R8000%20R90.pdf
Warm: http://www.nichia.co.jp/specification/products/led_spec/NSSLT02AT-V2-E(4371A)R8000%20R90.pdf

## Drivers

- I²DC

## Bluetooth Adapter

## Microcontroller

- 2-4 ADC channels
- Serial port (for bluetooth adapter)
- 2 hi-res PWM channels

328P Datasheet: http://www.atmel.com/images/Atmel-8271-8-bit-AVR-Microcontroller-ATmega48A-48PA-88A-88PA-168A-168PA-328-328P_datasheet_Complete.pdf

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


