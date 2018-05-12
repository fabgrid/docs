---
title: 'W06: 3D Scanning & Printing'
assignment: (1) Design and 3D print an object (small, few cm) that could not be made subtractively. (2) 3D scan an object (and optionally print it)
goal:
links:
 - text: additive.scad (source code)
   url: additive.scad
 - text: additive.stl (rendered model)
   url: additive.stl

layout: lesson
previous: fabacademy/week-05/index.md
next: fabacademy/week-07/index.md
---

## Table of Contents

* TOC
{:toc}

---

## A 3D object that could not be made subtractively

### Objective

One outstanding property of 3D printers is that they can build hollow objects, which couldn't be made subtractively.

> *Hollow* in this context means that the object contains cavities (volumes filled with air) that are embedded in the object in a way that not every point of the cavity can be reached from outside the object by a straight line that does not intersect with solid material.

This definition covers objects that cannot be made by classical machining from one piece. They could, however, be made using a milling machine (or other means) to produce individual parts that are assembled in a further step (eg. glue, welding, screws).

### Design

So how do we do it? Quite simple, if we don't want do make anything useful, but rather settle for art. We just need to make some kind of strucure inside of a structure. What about this:

<div class="row">
	<div class="col-sm-4"><zoom src="01-base-structure.png" caption="Our base structure…" /></div>
	<div class="col-sm-4"><zoom src="02-rotated.png" caption="…duplicated, rotated and scaled a couple of times" /></div>
	<div class="col-sm-4"><zoom src="03-cross-section.png" caption="Cross section reveals cavities" /></div>
</div>

### Slicing

Slicing is that step where the universal 3D model (usually as stl geometry) turns into machine-specific **gcode**. The latter is basically *assembly language for CNC-machines*, a series of raw instructions to the printer, telling it where to move (+ at which speed, + how much filament to extrude). It's is called *slicing* because the results express the model as a series of *slices*, which the printer can layer on top of each other along the z-axis.

Gcode is always more or less machine- and firmware-specific (just as assembly code is), as it is trimmed towards the machine's physical properties, such as the length of the individual axes, gearing ratios, movement speed & acceleration, filament diameter, etc.. It often is also specific to the type of material used, as it may contain information about nozzle and bed (sometimes also chamber) temperatures as well as control instructions for possible cooling systems. Some machines allow to choose those values directly at print time, accepting material-agnostic gcode without any temperature information.

<zoom src="04-slicr-screenshot.png" caption="Screenshot of the sliced model. Yellow is shell, red is fill, green is support material."></zoom>

The resulting instructions are quite easily readable by humans, as they're typically encoded in ASCII. The only thing one needs to know (or have a lookup table for) is the meaning of the various G- and M-codes. G-codes typically address the primary features of the machine (movement, extrusion), while M-codes are used for configuration and auxiliary features. Here is the first portion of our model's gcode (RepRap-compatible dialect) with some comments to explain what the instructions mean:

```gcode
M107
M190 S65 ; set bed temperature and wait for it to be reached
M104 S210 ; set temperature
G28 ; home all axes
G1 Z5 F5000 ; lift nozzle

; Filament gcode

M109 S210 ; set temperature and wait for it to be reached
G21 ; set units to millimeters
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion
G92 E0
G1 Z0.200 F7800.000
G1 E-1.00000 F2400.00000
G92 E0
G1 X103.627 Y78.865 F7800.000
G1 E1.00000 F2400.00000
G1 F1800
G1 X104.732 Y77.730 E1.04704
G1 X106.084 Y76.903 E1.09408
G1 X107.598 Y76.436 E1.14112
G1 X108.608 Y76.341 E1.17123
G1 X125.848 Y76.179 E1.68315
G1 X143.064 Y76.340 E2.19432
G1 X143.957 Y76.416 E2.22093
G1 X145.370 Y76.807 E2.26448
…
```

Different printer firmwares support different sets of instructions. Here's the gcode reference of the Marlin firmware, running on many open source, ATMega-based printer electronics: [http://marlinfw.org/meta/gcode/](http://marlinfw.org/meta/gcode/).

#### Software choice

A variety of open- and closed-source software exists for the job. Manufacturers of 3D printers ship their own solutions, some of them being forks of open source tools, others being developed completely from scratch. Often times, they can be used with other types of printers by simply creating a profile for the machine (specifying dimensions, nozzle size, movement speeds, etc.). Some noteworthy tools that can be used with many different machines:

- [Slic3r](https://github.com/alexrj/Slic3r) ([Prusa Edition](https://github.com/prusa3d/Slic3r/)) *[open source]* – my preferred one for its comprehensive feature set
- [Skeinforge](http://reprap.org/wiki/Skeinforge) *[open source]* – older generation open source slicer written in python
- [Simplify3D](https://www.simplify3d.com/) *[commercial]* – very advanced machine-agnostic slicer
- [Cura](https://ultimaker.com/en/products/cura-software) *[closed source]* – the one that ships with the Ultimakers

#### Key parameters

- **Layer height** – thickness of each layer in z-direction. Should be smaller than the nozzle diameter
- **Extruder & bed temperature** – according to the filament used
- **Infill percentage & pattern** – influences the density and thereby rigidity of the resulting object as well as print duration
- **Speed** – various speeds may be defined for various moves eg. first layer, perimeters, infill, travel moves
- **Support** – extra structures to support overhangs and other shapes that would otherwise be impossible to print "in the air"

### Printing

#### Warming up the printer

While the nozzle usually heats up quite quickly, the print bed can take a couple of minutes before it reaches its target temperature. In order to minimize waiting time, i usually tell the printer to heat up the printing bed, before even kicking off the slicing process.

#### Loading the code

In case of the Craftbot printers in our lab, the gcode needs to be loaded onto a USB tumbdrive that can be connected to the printer. On the small touchscreen, the appropriate file can be selected for printing.

#### Loading the filament

The nozzle needs to be heated up, before the old filament can be removed an the new one can be inserted. I recommend unrolling the approximately required length from the spool, because it could contain loops and i don't want my prints to fail because of a jammed filament spool. It is also recommended to wipe the filament before feeding it to the printer. This can be achieved by pushing it through a piece of sponge.

#### Preparing the print bed

I typically put a layer of *Blue painter's tape* on top of the printing surface. This makes the model stick much better and thereby reduces the risk of warping by a great deal. However, if you desire a smooth bottom surface on your model, this might not be ideal. In that case, make sure the build plate is super clean, using alcohol to remove any grease.

As a final step before starting the print, i recommend checking if the bed is level. Most printer firmware offer an option to (automatically or manually) calibrate the bed level. Use it frequently!

#### Result

The video of the print got lost (What a shame, the internet is definitely lacking 3d printing timelapse videos ;P), but here are some photos of the result:

<div class="row">
    <div class="col-sm-6"><zoom src="05-print-result-1.jpg"></zoom></div>
    <div class="col-sm-6"><zoom src="06-print-result-2.jpg"></zoom></div>
</div>

## 3D Scanning

In our fablab, we have an [iSense 3D Scanner](https://www.3dsystems.com/shop/isense/techspecs), that snaps onto an iPhone and allows 3D scanning with its dedicated iOS app. The process is fairly straight forward. After connecting the scanner to the phone and launching the app, it starts to detect its environment. I scanned a friend's head by walking around him in a circle, pointing the scanner towards the center (dont forget the top of the head). As you walk around, the app constructs a 3D mesh of the scanned object, sorry, subject in this case, trying to isolate it from the background.

<div class="row">
    <div class="col-sm-6"><zoom caption="The iSense camera mounted onto an iPhone" src="07-isense-on-iphone.jpg"></zoom></div>
    <div class="col-sm-6"><zoom caption="Not much choice in the UI" src="08-isense-user-interface.jpg"></zoom></div>
    <div class="col-sm-6"><zoom caption="Andreas scanning Benedikt" src="09-3d-scanning.jpg"></zoom></div>
    <div class="col-sm-6"><zoom caption="The raw scan result" src="10-scan-result.jpg"></zoom></div>
</div>

The only way to get the scanned model out of the iSense app is by email (lol). The received model looks quite good, but has some holes in it, that need to be patched. [Meshmixer](http://www.meshmixer.com/) or Autodesk Fusion can be used for that job. After some frustration with Fusion, i switched to Meshmixer.

<div class="row">
    <div class="col-sm-4"><zoom caption="Couldn't get Fusion 360 to do what i wanted it to" src="11-fusion-fail.png"></zoom></div>
    <div class="col-sm-4"><zoom caption="After switching to Meshmixer…" src="12-meshmixer-1.png"></zoom></div>
    <div class="col-sm-4"><zoom caption="…i somehow managed it." src="13-meshmixer-2.png"></zoom></div>
</div>

