---
title: 'W13: Molding & Casting'
assignment: Design a 3D mould, machine it, and cast parts from it.
goal: Create a knurled knob for adjusting color and brightness on the lamp.
links:
  - text: Casting candles
    url: candles/
  - text: dial-mold.scad (OpenSCAD Source)
    url: dial-mold.scad

layout: lesson
previous: fabacademy/week-12/index.md
next: fabacademy/week-14/index.md
---

## Table of Contents

* TOC
{:toc}

---

## CAD

First, i need to create a digital design of the dial wheel with the following specs:

- 50mm outer diameter
- 8mm thickness
- knurled rim
- center hole to mount it on the shaft of the rotary encoder

### Steps

1. Design "positive" model of the dial wheel
2. Add cast-on sections
3. Subtract from a solid to get the negative model
4. Split result into two halves
5. Add registration marks for proper alignment of the two halves

> This process is actually cheating – typically you mill a positive from which you can cast a "negative" mold. That mold in turn is used to cast the actual positive. The mold is typically made from a flexible material, like silicone. In my case, i hope i can directly cast my final part in the milled wax mold – let's see if it works…

### Execution

<div class="row">
    <div class="col-md-4"><zoom src="01-target-positive.png" caption="The target 'positive'"></zoom></div>
    <div class="col-md-4"><zoom src="02-cast-ons.png" caption="… with 'cast-ons'"></zoom></div>
    <div class="col-md-4"><zoom src="03-mold-halves.png" caption="The two halves of the mold"></zoom></div>
</div>

I open the model in FreeCAD, so i can export it as a `STEP` file from there. OpenSCAD can only export to mesh formats, which, when imported to Fusion 360 will be more difficult to handle. FreeCAD can parse scad models into its internal geometry model and export step files, which are more easily handled by Fusion than meshes.

<zoom src="06-import-result.png" caption="The bottom half opened in FreeCAD"></zoom>

## CAM

### Model Import

The `STEP` model can be easily imported into Fusion 360

### Tools Setup

I will use `2mm` and `.6mm` flat end mills. The parameters for 1/8” and 1/32” tools from [Bantam Tools' site on machinable wax](https://support.bantamtools.com/hc/en-us/articles/115001668653-Machining-Wax) roughly apply:

<div class="row">
    <div class="col-md-6">
        <h4>1/8” flat end mill:</h4>
        <table>
            <tr><th>Parameter</th><th>Value</th></tr>
            <tr><td>Feed rate</td><td>1500 mm/min</td></tr>
            <tr><td>Plunge rate</td><td>500 mm/min</td></tr>
            <tr><td>Spindle speed</td><td>16,400 RPM</td></tr>
            <tr><td>Max pass depth</td><td>3 mm</td></tr>
        </table>
    </div>
    <div class="col-md-6">
        <h4>1/32” flat end mill:</h4>
        <table>
            <tr><th>Parameter</th><th>Value</th></tr>
            <tr><td>Feed rate</td><td>1500 mm/min</td></tr>
            <tr><td>Plunge rate</td><td>500 mm/min</td></tr>
            <tr><td>Spindle speed</td><td>16,400 RPM</td></tr>
            <tr><td>Max pass depth</td><td>1.5 mm</td></tr>
        </table>
    </div>
</div>

<br />

#### Fusion 360 Tool Library

<div class="row">
    <div class="col-md-6"><zoom src="07-tool-setup.png" caption="Creating a new tool in the library"></zoom></div>
    <div class="col-md-6"><zoom src="08-tool-library.png" caption="Both tools in the library"></zoom></div>
</div>

<div class="alert alert-warning">Make sure to create your tools in the "local" library. When you create them inside the "document" library, they will not be available for use in other projects.</div>

### Milling passes

1. Roughing pass (2mm end mill)
2. Facing pass for surfaces in Z-plane (2mm end mill)
3. Finishing pass for "low detail" vertical faces (2mm end mill)
4. Finishing pass for the tiny vertical surfaces of the teeth (.6mm end mill)

#### 1. Roughing pass

First, we use a *adaptive clearing* strategy to efficiently clear most of the material, but leave some stock for the detail passes.

<div class="row">
    <div class="col-md-8"><zoom src="09-roughing-pass-paths.png" caption="'Adaptive clearing' calculated machine paths"></zoom></div>
    <div class="col-md-4"><zoom src="10-roughing-pass-params.png" caption="'Adaptive clearing' strategy parameters"></zoom></div>
</div>

#### 2. Z-Facing pass

Using a *facing* strategy, we finish all surfaces in the XY-plane.

<div class="row">
    <div class="col-md-8"><zoom src="11-facing-pass-paths.png" caption="'Facing' calculated machine paths"></zoom></div>
    <div class="col-md-4"><zoom src="12-facing-pass-params.png" caption="'Facing' strategy parameters"></zoom></div>
</div>

#### 3. Vertical finishing

Still using the 2mm tool, we finish the "low detail" vertical surfaces, namely the registration marks. I choose a *contour* strategy for that job.

<div class="row">
    <div class="col-md-8"><zoom src="13-vertical-finishing-pass-paths.png" caption="'Contour' calculated machine paths"></zoom></div>
    <div class="col-md-4"><zoom src="14-vertical-finishing-pass-params.png" caption="'Contour' strategy parameters"></zoom></div>
</div>

#### 4. Teeth Finishing pass

In the final pass, we use a .6mm mill to finish the fine details of the knurled perimeter, also with a *contour* strategy.

<div class="row">
    <div class="col-md-8"><zoom src="15-detail-pass-paths.png" caption="'Contour' calculated machine paths"></zoom></div>
    <div class="col-md-4"><zoom src="16-detail-pass-params.png" caption="'Contour' strategy parameters"></zoom></div>
</div>

## Milling the Mold

### Setup

Using the "measure" tool in Fusion, i determine the total dimensions of the model (58x58mm). I then cut some milling wax to that size, roughly 60x60mm. Finally, i adjust the stock in Fusion to be slighly larger than that (62x62mm) in order to compensate for any inaccuracies.

<div class="row">
    <div class="col-md-5"><zoom src="19-stock-measuring.jpg" caption="Measuring the stock material"></zoom></div>
    <div class="col-md-6"><zoom src="20-stock-setup.png" caption="Enter stock dimensions plus tolerance"></zoom></div>
</div>

So we're ready to regenerate all toolpaths and run the post-processor to generate g-code for the Othermill. Before i send the code to the machine, it is very important to **run a simulation** in order to detect any possible collisions upfront.

<div class="alert alert-warning">Initially, the postprocessor failed with an "!Error: Failed to post data. See log for details." warning. I had to select the operations manually and export them as separate gcode files per tool. Might be something with the tool changing procedure and g-codes of the Othermill…</div>

<div class="row">
    <div class="col-md-6"><zoom src="17-bantam-tools.png" caption="The gcode file opened in BantamTools"></zoom></div>
    <div class="col-md-6"><zoom src="18-bantam-tools-tool-library.png" caption="Tool library in BantamTools"></zoom></div>
</div>

### Milling

Having fixed the wax block onto the sacrificial plate (using double-sided tape 🤭), we can start milling:<br/>

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/u29A-RUgrFg" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Casting

The resin we have fortunately declares itself as *weakly exothermic* – good for my wax mold. It already has lots of chunks in it, but it had that already when i used it last time and it worked when carefully pouring only the liquid parts.

<div class="row">
    <div class="col-md-4"><zoom src="21-resin.jpg" caption="Old but should still work"></zoom></div>
    <div class="col-md-7"><zoom src="22-mold-and-funnel.jpg" caption="The bandaged mold with its tailor-made funnel"></zoom></div>
</div>

### Unmolding
**Two weeks later:**<br/>
(one or two days would have been enough)<br/>

<div class="row">
    <div class="col-md-6"><iframe width="480" height="270" src="https://www.youtube-nocookie.com/embed/zt8nTHznxkw" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>
    <div class="col-md-6"><zoom src="23-finished-cast.JPG" caption="The finished cast"></zoom></div>
</div>

## Questions & Notes

- Would the machining marks not have impressed onto the final piece, if i had used the typical "two-step" molding process?
- I apparently left too little extra resin in the funnel, so it sucked in air and created that dent. Might have been neccessary to attach another funnel to the "outlet hole" to establish equal pressure at both ends. I'm also wondering why it didn't suck in air from the "outlet".
