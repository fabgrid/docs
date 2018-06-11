---
title: 'W10: Mechanical Design'
assignment: Make a machine, including the end effector, build the passive parts and operate it manually
goal: Design and build a pen plotter
links: []

layout: lesson
previous: fabacademy/week-09/index.md
next: fabacademy/week-11/index.md
---

## Table of Contents
* TOC
{:toc}

---

I have some spare [V-Slot](http://openbuildspartstore.com/v-slot-20x40-linear-rail/) linear extrusions along with accessories. Let's use them to build a simple pen plotter. It could later be rebuilt into a general purpose 2.5-3 axis CNC machine, which would likely require a more rigid design in most cases.

<zoom src="http://cdn8.bigcommerce.com/s-itwgldve/images/stencil/608x608/products/312/2498/V-Slot_20x40_clear_s_w_2__95354.1510262987.png"></zoom>

## Design
Currently, i'm thinking of a simple "T" style design with only one linear actuator per axis. As we're not building a heavy-duty CNC machine, but rather just a plotter, forces should be small enough to allow for that kind of setup.

### Parts Library
The design is developed around the V-Slot extrusions, so using the [Openbuilds OpenSCAD library](https://github.com/mazerte/openscad-openbuilds) can save us some time.

A quick test to see if it's working:

<div class="row">
    <div class="col-md-6"><zoom src="01-library-code.png"></zoom></div>
    <div class="col-md-6"><zoom src="02-library-result.png"></zoom></div>
</div>

### Process
1. Design a common linear actuator
2. Design the Y-axis
3. Design the X-axis
4. Design the Z-axis (end effector)
5. Assemble everything
6. Animate

#### Linear actuator
A linear actuator consists of:

- a length of extrusion
- a "passive end" with the idler pulley
- an "active end" with the stepper motor
- the gantry
- the belt (maybe omit that from the CAD)

The motor stems from the `MCAD` library, which is bundeled with OpenSCAD. The pulleys are included in `openscad-openbuilds`. I couldn't find a model of the *end mount* for the motor and idler pulley, so i designed it myself. I likely would have needed that custom model anyway, because i want to print them, instead of buying them for 10€ each.

#### X and Y axis
After modelling the linear actuator, "assembling the axes" is quite simple: Just put two of them on top of each other:

<zoom src="03-axes.png" caption="X- and Y-axes"></zoom>

The X motor kind of acts as a counterweight

#### End effector
The end effector (Z axis) will slide on cheap 8mm smooth rod with LM8UU linear bearings. It will push the pen downwards using a spring and be able to lift it with a servo. The assembly could be mounted upside down to inverse this logic so that the pen would be pushed **up** by the spring and **down** by the servo. I prefer the former approach because this way the spring acts as a suspension while drawing, smoothing out any irregularities in the drawing surface and reducing forces at the pen tip.

<zoom src="04-end-effector.png" caption="The end effector (bearings and servo lever missing)"></zoom>

## Build Steps
Building with Openbuilds parts is quite straight forward and requires not much explanation:

### Linear Actuator Build
<div class="row">
    <div class="col-md-3"><zoom src="05-actuator.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="06-actuator.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="07-actuator.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="08-actuator.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="09-actuator.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="10-actuator.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="11-actuator.JPG"></zoom></div>
</div>

### End Effector Build
<div class="row">
    <div class="col-md-3"><zoom src="12-end-effector.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="13-end-effector.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="14-end-effector.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="15-end-effector.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="16-end-effector.JPG"></zoom></div>
    <div class="col-md-3"><zoom src="17-end-effector.JPG"></zoom></div>
</div>

## Manual Operation
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/w75ygAgBhCk" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Individual Contribution
Though this assignment is a group assignment (and requires to describe the individual's contribution), i did the design and build by myself, as i didn't find the time to visit to the lab and coordinate with the other student.

## Improvements
- Add end stops
- Smarter pen holder
- Increase counterweight or add wheel to the loose end of the X axis
- Use thinner rod for the end effector 4 or 6mm (8mm is what i happened to have around)
