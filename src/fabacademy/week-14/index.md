---
title: 'W14: Input Devices'
assignment: Design and build a wired &/or wireless network connecting at least two processors
goal: "Check the current on the USB charger i recently built"
links:
  - text: "Board Design (Upverter)"
    url: "https://upverter.com/jsphpl/e92e2d39c8118dc0/attiny-current-display/"
  - text: "Board Design (zip)"
    url: "board.zip"
  - text: "Source Code"
    url: "code.zip"
  - text: "Allegro ACS712 Datasheet"
    url: "http://datasheet.octopart.com/ACS712ELCTR-05B-T-Allegro-datasheet-13439546.pdf"
  - text: "Atmel ATTiny x4 Datasheet"
    url: "http://www.atmel.com/images/doc8006.pdf#page=5&zoom=auto,-193,713"
  - text: "USB Charger Design"
    url: "https://upverter.com/jsphpl/667db3f77daca370/step-down-usb-monitored-smt-alt/"

layout: lesson
previous: fabacademy/week-13/index.md
next: fabacademy/week-15/index.md
---

## Table of Contents

* TOC
{:toc}

---

## Input Devices

A few weeks ago, i buit a USB charging station for our Fablab's booth at an arts festival. It features a 10A step-down converter ([TI LMZ22010](http://www.ti.com/lit/ds/symlink/lmz22010.pdf)) to supply 4 USB ports with lots of power. The data pins on the USB connectors were configured so that two of the ports would allow Android devices to draw full current and two to allow the same thing to iOS devices.

It also contains a hall-effect based current sensor, that outputs a DC voltage corresponding to the current drawn, the *Allegro ACS712*. Let's make a board that reads this voltage and displays some stats on an LCD, to see how much power our devices really draw.

<zoom src="01-usb-board.png" caption="Board layout of the usb charging circuit (link to source and schematic at the top of this page)"></zoom>

## Hardware

To read and disply the output from our USB charger, i design a really simple board:

- ATTiny44
- ISP header
- An LED for debugging purposes
- One analog in to read from our USB charger
- Two digital I/Os to display some data on a serial LCD

### Design

I am recently doing all my PCB designs on [upverter.com](upverter.com). Its parts library is okay and it's got that beautiful feature called "Parts Concierge" - people making component footprints for you, according to datasheets you submit. I was using it for one of the USB connectors. After swapping the part for a different model for the third time, it's such a good feeling to have someone help you on that detailed work ;)

<div class="row">
	<div class="col-md-4"><zoom src="02-input-board-schematic.png" caption="Quite simple schematic"></zoom></div>
	<div class="col-md-4"><zoom src="03-input-board-components.png" caption="Component Locations"></zoom></div>
	<div class="col-md-4"><zoom src="04-input-board-traces.png" caption="Top Copper Layer"></zoom></div>
</div>

### Production

I tried some <a href="https://www.bungard.de/index.php/de/produkte/oberflaechen/green-coat">Bungard Green Coat</a> on this board, looks like i took a bit too much.

<div class="row">
	<div class="col-md-3"><zoom src="07-raw-board.jpg"></zoom></div>
	<div class="col-md-3"><zoom src="08-green-board.jpg"></zoom></div>
	<div class="col-md-3"><zoom src="11-components.jpg"></zoom></div>
	<div class="col-md-3"><zoom src="12-board-soldered.jpg"></zoom></div>
</div>

## Software

The ATTiny44 provides only little space (4KB) for our code. Using the SoftSerial library in Arduino would already occupy more than half of the program memory. Because fighting for each single bit sucks, we're gonna implement this in "bare C".

### Basic Test

Just a quick test upfront to see that the board is working and can be programmed – our good ole' *Blink* sketch:

<zoom src="09-board-blink.jpg"></zoom>

### Serial Communication

For the serial communication i found a really small [library on the internet](http://www.bot-thoughts.com/2013/11/attiny-software-serial.html). I had to shift the table for the timings a bit, so it would correctly work at 8 MHz. Otherwise, i would have had to set the baud rate to 19200 for it to actually talk at 9600.

### Analog Input

With a little bit of testing and tweaking, i created two functions based on information from the Atmel datasheet and Neil's example code:

```c
/**
 * Enable the ADC, set mode and channel.
 */
void adc_init()
{
    ADMUX = (0 << REFS1) | (0 << REFS0)  // VCC ref
      | (0 << MUX5) | (0 << MUX4) | (0 << MUX3) | (0 << MUX2) | (1 << MUX1) | (1 << MUX0);  // PA3 (ADC3)
    ADCSRA = (1 << ADEN)  // enable
      | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);  // prescaler /128
}

/**
 * Read the ADC and return a 10-bit value as integer.
 *
 * @return int
 */
int adc_read()
{
    ADCSRA |= (1 << ADSC);  // initiate adc reading
    while (ADCSRA & (1 << ADSC));  // wait for completion

    byte less_significant = ADCL;  // Read ADC registers, ADCL has to be read first
    return less_significant | ADCH << 8;
}
```

### So far so good…

Before actually hooking up the LCD, i first check if the analog values are read correctly by feeding a UART signal back to my computer through an ordinary FTDI cable. Later i will connect the Rx of the LCD to the microcontroller's Tx pin, instead of the FTDI adapter's Rx, that is connected right now.

<div class="row">
	<div class="col-md-6">
		<zoom src="05-raw-values.png" caption="Raw values from free-floating ADC input"></zoom>
	</div>
	<div class="col-md-6">
		<zoom src="06-current-output.png" caption="Input converted to mA and wrapped in LCD's protocol"></zoom>
	</div>
</div>

I also implement a function to wrap the "protocol" that my LCD display understands. Before hooking up the LCD, i connect the FTDI adapter and inspect the output through `miniterm.py`.

```c
/**
 * Print given string on given line of a 2x8-char
 * serial LCD from iteadstudio.com
 *
 * @param line Line number (0|1)
 * @param text
 */
void lcd_print(byte line, char text[8]) {
    // Go to start of line
    char start[6];
    sprintf(start, "sd%i,0;", line);
    print(start);

    // Clear line
    print("ss        ;");

    // Go to start again
    print(start);

    // Print actual message
    char message[11];
    sprintf(message, "ss%s;", text);
    print(message);
}
```

### Where it failed

- Mostly nothing on the LCD
- Only occasional (even meaninful) output
- Using a logic sniffer, i couldn't detect any meaninful conversation going on at a common baud rate
- Probably the different input voltage (3.3 from the FTDI cable vs 5 from the DC supply) made the internal oscillator behave differently
- Also, the lack of a capacitor on the board's VCC might bring in some trouble
- Conclusion: Re-design the board, add external oscillator, add input capacitance

<zoom src="10-result.jpg" caption="The best result i could get. The value doesn't make any sense but at least we know it's mA ;)"></zoom>

<div class="alert alert-info">
  <strong>Pro tip:</strong> Choose a processor with hardware UART if your project requires UART ;)
</div>
