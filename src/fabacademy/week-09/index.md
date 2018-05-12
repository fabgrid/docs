---
title: 'W09: Embedded Programming'
assignment:  Program your board to do something, with as many different programming languages and programming environments as possible
goal: Use the Arietta G25 (ARMv9) that's been lying around for a couple of years
links:
 - url: https://www.acmesystems.it/documentation
   text: Arietta Documentation
 - url: https://github.com/jsphpl/arietta-ring-benchmark
   text: Ring oscillator source code
 - url: http://www.atmel.com/products/microcontrollers/arm/sam9g.aspx
   text: Atmel info on SAM9G ARM9

layout: lesson
previous: fabacademy/week-08/index.md
next: fabacademy/week-10/index.md
---

## Table of Contents

* TOC
{:toc}

---

## Programming an AVR board

TBD…

## Programming an ARM board

I have two of these [Arietta G25](https://www.acmesystems.it/arietta) boards around, which i bought really cheaply a few years ago. They feature a 400MHz ARMv9 with 128MB of RAM and some 3V3 GPIO pins. Should be enough for some basic projects requiring a Linux kernel. Today, i'd rather buy a [Raspberry Pi Zero W](https://www.raspberrypi.org/products/pi-zero-w/) at 11€. That's a no-brainer, considering that they have WiFi and BTLE on board, plus much higher CPU frequency and RAM. The G25 is available today at their store at around 25€, but considering the Pi Zero, there's no reason to buy it, except for a possibly lower power consumption.

<zoom src="01-arietta-g25.jpg" caption="An <em>Arietta G25</em> ARM board"></zoom>

### 1. Preparing the microSD card

The image provided by Acme Systems requires an SD card with two partitions:

| Index | Filesystem | Label  |  Size  |
|-------|------------|--------|--------|
| 1     | FAT32      | boot   |  >64MB |
| 2     | EXT4       | rootfs | >800MB |

The process using gparted on Linux is described in the [official instructions](https://www.acmesystems.it/microsd_format). On macOS, things look a bit different, as there's no native support for EXT filesystems. Being too lazy to switch to a Linux machine, i got around this by using the free trial version of [Paragon ExtFS](https://www.paragon-software.com/home/extfs-mac/features.html), a commercial EXT filesystem driver for Mac. After the installation, the computer needs a reboot. Then you can use any EXT2/3/4 filesystem just like a native one:

<zoom src="02-supported-filesystems-ext.png" caption="Supported filesystems after the installation of <em>Paragon ExtFS</em>. Normally, all EXT2/3/4 entries wouldn't be there."></zoom>

This means, we can now prepare our SD card using the `diskutil` command with root privileges. When copying the code below, be sure to replace `/dev/disk3` with the actual location of your SD card.

```bash
diskutil partitionDisk /dev/disk3 2 MBR fat32 BOOT 128M UFSD_EXTFS4 rootfs R
```

<div class="alert alert-success">
    <strong>Explanation:</strong> The above command asks the system to create a <strong>MBR</strong> layout with <strong>2</strong> partitions. The first partition will be formatted with <strong>fat32</strong>, named <strong>BOOT</strong> and have a size of <strong>128MB</strong>. The second partition will be formatted using <strong>UFSD_EXTFS4</strong> (= ext4) and named <strong>rootfs</strong>, spanning all the <strong>R</strong>emaining free space.
</div>

On success, the two new partitions should be mounted at `/Volumes/BOOT` and `/Volumes/rootfs`, respectively.

### 2. Installing the pre-built Debian OS

Getting the Arietta G25 up and running is pretty straight-forward. Acme Systems, the vendor of the G25, provides a Debian Jessie 8.4 Image @Linux 4.4.8 [on their website](https://www.acmesystems.it/binary_repository). *Be sure to choose the correct device from the tab bar on the downloads page!*

1. Download the `rootfs.tar.bz2` and `boot.tar.bz2` archives from the above link
2. Untar the rootfs to our newly partitioned SD card: `tar -xvjpSf rootfs.tar.bz2 -C /Volumes/rootfs`
3. Also untar the BOOT partition image: `tar -xvjpSf boot.tar.bz2 -C /Volumes/BOOT`
4. Unmount both volumes: `diskutil unmount /dev/disk3s1; diskutil unmount /dev/disk3s2`

**Done.**

### 3. Checking the installation

1. Insert the microSD card into the Arietta
2. Connect the Board to a Linux or macOS machine using a Micro-USB cable
3. After a few seconds, the greed LED on the upper side of the Board should start to blink, indicating that the kernel is running
4. The Arietta's USB port acts as a virtual network adapter. Configure it on your host machine, by assigning it a fixed IP address of `192.168.10.20` and the subnet mask `255.255.255.0`
5. Ping arietta to see if the network connection works: `ping 192.168.10.10`
6. Ping arietta using its hostname to test bonjour: `ping arietta.local`
7. If both pings are successful, nothing should keep you away from `ssh root@arietta.local` using *acmesystems* as password
8. Running the `top` command on the arietta reveals that 99% of the system memory are occupied, but, at the same time, proves the G25 to be working ;)

<div class="row">
    <div class="col-md-4">
        <zoom src="07-kernel-led.jpg" shadow="true" caption="Kernel up → LED blinks"></zoom>
    </div>
    <div class="col-md-4">
        <zoom src="03-network-static-ip.png" caption="Static IP configuration for the virtual network adapter"></zoom>
    </div>
    <div class="col-md-4">
        <zoom src="04-top-memory-full.png" caption="The <code>top</code> command reports 1976 KiB of free memory"></zoom>
    </div>
</div>

### 4. Attaching a serial debug terminal

<div class="row">
    <div class="col-lg-3"><zoom src="06-shift-ftdi-adapter.jpg" class="shadow"></zoom></div>
    <div class="col-lg-9"><p></p>
        <p>Let's connect to the serial terminal in order to ensure a stable connection, should the networking/ssh path fail. This is also useful to catch boot messages when playing with the kernel or filesystem. Looking up the <a href="https://www.acmesystems.it/pinout_arietta">pinout</a>, turns out i can directly connect a standard 3.3V FTDI cable to the non-standard Shift-By-1® connector ;)</p>
    </div>
</div>

### 5. Ring oscillator benchmark

<div class="row">
    <div class="col-md-9">
        <p>Now i want to use the GPIO pins on the Arietta G25 to perform a benchmark using the ring oscillator setup that <a href="http://fab.cba.mit.edu/collab/ring/">Neil mentioned</a>. In order to get a more realistic view of the raw throughput, i'll build a custom rootfs with just the required packages, following <a href="https://www.acmesystems.it/debian_jessie">these instructions</a>. But that's beyond the scope of this page…</p>

        <p>The <a href="https://www.acmesystems.it/gpio">official documentation</a> on the Arietta GPIO states three different APIs to the GPIO: Sysfs, Python, and C. I will try to use the Python and C bindings, expecting C to yield higher frequencies than Python.</p>

        <p>As suggested in the GPIO documentation, the <a href="https://raw.githubusercontent.com/tanzilli/gpiolib/master/gpiolib.c">gpiolib.c</a> (C) and <a href="https://github.com/acmesystems/acmepins">acmepins</a> (Python) libraries will be used for the tests.</p>

        <p>All source code used in the tests can be found in the Github repository linked at the top of this page under <em>#Further Resources</em>.</p>
    </div>
    <div class="col-md-3">
        <zoom src="05-g25-pinout.jpg" alt="Arietta G25 GPIO pinout" caption="<a href='https://www.acmesystems.it/pinout_arietta'>Arietta G25 GPIO pinout</zoom>"></zoom>
    </div>
</div>

#### Test Code

##### Python

The identifiers for the pins can be found in the [acmepins source code](https://github.com/AcmeSystems/acmepins/blob/master/acmepins.py#L35...L63).

```python
from acmepins import GPIO

pin_out = GPIO('J4.39','OUTPUT')  # PC0
pin_in = GPIO('J4.37','INPUT')    # PC1

while True:
    pin_out.digitalWrite(0 if pin_in.digitalRead() else 1)
```

There seems to be a bug in GPIO.digitalRead(). It is fixed by **replacing `pinlevel[level]` with just `level` in `acmepins.py:783`.** This is the behaviour we expected, anyway…

```
NameError: global name 'pinlevel' is not defined
```

##### C

The kernel ids of the pins can be found here: [https://www.acmesystems.it/pinout_kernelid](https://www.acmesystems.it/pinout_kernelid)

```c
#include <stdbool.h>
#include "gpiolib.c"

#define DIR_IN  1
#define DIR_OUT 0
#define PIN_OUT 64
#define PIN_IN  65

bool input;

void main() {
    while (true) {
        // Read value from input
        gpioexport(PIN_IN);
        gpiosetdir(PIN_IN, DIR_IN);
        input = gpiogetbits(PIN_IN);

        // Write inverse value to output
        gpioexport(PIN_OUT);
        gpiosetdir(PIN_OUT, DIR_OUT);
        if (input == 1) {
            gpioclearbits(PIN_OUT);  // set low
        } else {
            gpiosetbits(PIN_OUT);    // set high
        }
    }
}
```

The abode code also produces an error on compilation, which can again be resolved by a small edit to the library: **Remove the entire `main()` function from `gpiolib.c`.**

```
gpiolib.c:155:6: note: previous definition of 'main' was here
 void main(void) {
      ^
```

#### The Result

The oscilloscope shows a quite disillusioning result: *roughly **200 Hz** with both Python and C – that's 2 million CPU cycles @ 400 MHz!*

<div class="row">
    <div class="col-sm-6">
        <zoom src="08-osci-result-py.jpg" shadow="true"></zoom>
    </div>
    <div class="col-sm-6">
        <zoom src="09-osci-result-c.jpg" shadow="true"></zoom>
    </div>
</div>

On reptition of the experiment using a logic analyzer to measure the frequency, our fears shall be confirmed.

<div class="row">
    <div class="col-sm-6">
        <zoom src="10-logic-analyzer-result-py.png" caption="Python performs at 213 Hz"></zoom>
    </div>
    <div class="col-sm-6">
        <zoom src="11-logic-analyzer-result-c.png" caption="…C only 183 Hz – what's wrong?"></zoom>
    </div>
</div>

I doubt the experiment and test an Arduino with the same setup in order to make sure nothing's wrong with my test equipment / code / procedure.

For a quick test, i hack up the following code and load it onto a Trinket:

```cpp
#define PIN_OUT 0
#define PIN_IN  1

void setup() {
    pinMode(PIN_OUT, OUTPUT);
    pinMode(PIN_IN, INPUT);
}

void loop()  {
    digitalWrite(PIN_OUT, 1-digitalRead(PIN_IN));
}
```

At a frequency of around 90 KHz, the Arduino result is much closer to the expected range. This should confirm the methodology. The results are close to the Arduinos in the [chart](http://fab.cba.mit.edu/collab/ring/), so there's no need for a plain-C test. Still, the result is disturbing: **GPIO on a 16MHz AVR through Arduino is three orders of magnitude faster than on a 400MHz ARM through Linux-Sysfs-Python/C.**

<zoom src="12-arduino-results.png" caption="The AVR through Arduino performs much better"></zoom>
