---
title: 'W11: Machine Design'
assignment:
goal:
links: []

layout: lesson
previous: fabacademy/week-10/index.md
next: fabacademy/week-12/index.md
---

## Table of Contents

* TOC
{:toc}

---

## Firmware

There is a nice fork of the original [GRBL](https://github.com/gnea/grbl) that works with a servo instead of a spindle:
[https://github.com/cprezzi/grbl-servo](https://github.com/cprezzi/grbl-servo)

### Configuration

I had to make just a few adjustments to `defaults.h` in order to set the machine properties, such as axis lengths, accelerations and steps per unit.

**defaults.h**
```cpp
  // […]
  #define DEFAULT_X_STEPS_PER_MM 53.555
  #define DEFAULT_Y_STEPS_PER_MM 53.555
  // […]
  #define DEFAULT_X_MAX_RATE 6400.0 // mm/min
  #define DEFAULT_Y_MAX_RATE 6400.0 // mm/min
  // […]
  #define DEFAULT_X_ACCELERATION (80.0*60*60) // 80*60*60 mm/min^2 = 80 mm/sec^2
  #define DEFAULT_Y_ACCELERATION (80.0*60*60) // 80*60*60 mm/min^2 = 80 mm/sec^2
  // […]
  #define DEFAULT_X_MAX_TRAVEL 300.0 // mm NOTE: Must be a positive value.
  #define DEFAULT_Y_MAX_TRAVEL 300.0 // mm NOTE: Must be a positive value.
  // […]
  #define DEFAULT_DIRECTION_INVERT_MASK 1 // invert X axis
  // […]
```

### Compile & Flash

After changing values in the code, it needs to be recompiled and flashed (requires `avr-gcc` and `avrdude`):

```sh
make
make flash
```

In order to restore settings in the EEPROM to their firmware defaults, one can issue the following command via serial terminal:

```
$RST=*
```

### How to connect the servo to the GRBL board?

Everything worked fine except for the servo control. According to the [readme](https://github.com/cprezzi/grbl-servo), one should be able to control the servo using `M3 S0` … `M3 S255` commands. I assumed that the servo had to be connected to the *"Spindle Enable" (D12)* pin, which vanilla GRBL can natively drive using PWM. Took me a while before i found the following in grbl's `config.h`:

> When enabled, the Z-limit pin D11 and spindle enable pin D12 switch! The hardware PWM output on pin D11 is required for variable spindle output voltages.

Hooked the servo up to `D11` instead, and suddely it worked! Magic! Only thing left to do was to adjust minimum and maximum pulse values in order to restrict servo movement to the absolutely necessary:

**cpu_map.h:127-132**
```cpp
  #ifdef SPINDLE_IS_SERVO
    #define SPINDLE_PWM_MAX_VALUE     60
    #ifndef SPINDLE_PWM_MIN_VALUE
      #define SPINDLE_PWM_MIN_VALUE   20
    #endif
  #else
```

## Control Software

### GCode generation
Inkscape Plugin: https://github.com/arpruss/gcodeplot (there you can set the gcode to lift and lower the pen using the servo as "before path" and "after path" actions)

### Machine control & GCODE sender
[http://chilipeppr.com/jpadie](http://chilipeppr.com/jpadie) (the jpadie workspace is compatible with latest GRBL)

## Computer-controlled Operation:
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/or-OBGDfo-E" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

