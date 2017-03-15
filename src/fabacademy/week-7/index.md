---
title: 'W7: Computer Machining'
assignment: Make something big
goal: Finally make my standing desk
links:
 - text: jsphpl/standesk (OpenSCAD model)
   url: https://github.com/jsphpl/standesk
 - text: MasterPro 2513 (CNC mill)
   url: http://www.elsign-cnc.com/milling-machines/easyworker-masterpro/2513.html

layout: lesson
previous: fabacademy/week-6/index.md
next: fabacademy/week-8/index.md
---

---

<img src="01-standesk-cover.jpg" class="img-fluid" />

---

## Table of Contents

* TOC
{:toc}

---

## Design

I made the original design of the desk back in 2014, when i thought i needed a standing desk to relieve my back (The table was never made in lack of a large enough CNC mill – until last week). The principles of the design were the following:

- Only wood, no screws or other fixture
- As little waste as possible (from a single 2.50m x 1.25m multiplex board)
- No other tools than a CNC mill
- Fully parametric

### Design Improvements

Some adjustments to the design had to be made:

- Add dogbones to make it machinable on the cnc router
- Add fillets to concave corners to make them machinable
- Round convex corners in order not to kill ourselves
- Add an extra joint to test how tight everything will fit
- Add a supportive strut right below the tabletop

#### Dog vs. Mouse

Back when i created it, i wasn't aware that the original design – without accounting for the tool diameter – would be useless for a CNC router. So one thing i had to change was to add that little dogbone fillets. Of course, they too are parametric and their radius is calculated as <math><mfrac><mrow><mn>1</mn></mrow><mrow><mn>1.9</mn></mrow></mfrac><mrow><mo>&times;</mo><mi>tool diameter</mi></mrow></math> in order to leave just a little tolerance so the CAM processor doesn't ignore those areas as too small for the tool.

The position of the circle relative to the rectangle whose corners it's trying to ensure is actually quite easy to calculate. First, i did it wrong and placed the center of the circle right on top of the corner, which gives you rather a *Mickey Mouse* than a *Dog Bone*.

The correct center of the circle is on a 45° diagonal, offset by the radius from the corner towards the center of the rectangle. This way, the circle goes right through the corner, ensuring that just enough material is removed. Thanks to <a href="http://fabacademy.org/archives/2013/students/meier.ferdinand/index.html">Ferdy</a> for helping me figure this out!

<div class="row">
	<div class="col-sm-6">
		<img src="02-fillets-mickey-mouse.png" class="constrain" alt="bad mickey mouse fillets" />
		<span class="img-caption">Wrong placed "<strong>Mickey Mouse</strong>" fillets</span>
	</div>
	<div class="col-sm-6">
		<img src="03-fillets-dog-bone.png" class="constrain" alt="calculating dogbone fillets positions" />
		<span class="img-caption">Well placed, <strong>actual dog bone</strong> fillets</span>
	</div>
</div>


## Production

### Outline

When the design is ready, the process continues as follows:

1. Measure stock thickness (12.15mm)
2. Enter the correct tool diameter (4mm)
3. Recalculate the model based on the obtained values
4. Mill a test joint from the same panel that's gonna be used for the actual table
5. Adjust clearance or stock thickness if joint doesn't fit as desired
6. Mill the table (first inside cuts, then outside)
7. Clean the cutting edges (sand paper)
8. Assemble everything
9. Oil?

### Model Parameters

The model has to be adjusted by setting some variables inside the OpenSCAD file.

- Take the diameter of the end mill from its data sheet
- Measure the width and length of the stock. Subtract about 10mm on each side as a safety margin, depending on how exact you can place it on the milling table
- Measure the exact thickness of the stock. Use a caliper to take multiple measurements on each side. Average them.

```openscad
TOOL_DIAMETER = 4;          // in mm
STOCK_WIDTH = 1210;         // in mm
STOCK_LENGTH = 2480;        // in mm
STOCK_THICKNESS = 12.15;    // in mm
$fn = 50;                   // Number of circle segments. Set this to ≥50 for production (≤30 for development)
```

### Final Checks

#### 1. Assembled

Make a visual check of the assembled model to see if everything is there and in the right place. Also check if all holes for the joints are present. Set `FLAT = false;` and refresh the OpenSCAD *Preview*, then pan/rotate around with the mouse to inspect everything.

<img src="04-design-screenshot-openscad.png" class="constrain" alt="jsphpl/standesk OpenSCAD design" />
<span class="img-caption">"Assembled" view of the final design</span>

#### 2. Flat

Switch the model back to flat:

```openscad
FLAT = true;
PROJECTION = false;
```
Again, refresh the preview. **Check if everything fits inside the gray box**, which represents your stock panel minus the safety margins (values entered for `STOCK_WIDTH` and `STOCK_LENGTH`).

<img src="05-design-screenshot-flat.png" class="constrain" alt="Flat view of the jshpl/standesk design" />
<span class="img-caption">"Flat" view – all parts packed into a single board (gray)</span>

### Render & Export

When all checks have passed, we switch both `FLAT` and `PROJECTION` variables to `true`. This time, we use the *Render* function (F6) instead of *Preview*. This process will take a couple of minutes, mainly depending on the tasked machine's performance and the chosen value for `$fn`.

At the end of the process, we get our exact 2D outlines which we'll export to DXF format.

<img src="06-openscad-export.png" class="constrain shadow">

### CAM Preprocessing

Now these DXF outlines need to be prepared for the CAM step which will take place directly on the PC that controls the milling machine.

Our task is to group together all paths that need to be processed using the same strategy. The CAM-software we're using requires them to have different colors. We take [Rhino](https://www.rhino3d.com/) for this purpose.

**1. Import DXF into Rhino**

**2. Select everything (CMD+A) and `join` all segments in order to close paths**

<img src="07-rhino-close-paths.png" class="constrain" />

**3. Create four different layers and move the respective elements there. Assign each layer a distinct color.**

- Inside cut: Joint test
- Outside cut: Joint test
- Inside cut: Main
- Outside cut: Main

<img src="08-rhino-layers.png" class="constrain" />

**4. Export to DXF with the `R12 Lines & Arcs` scheme**

<img src="09-rhino-export.png" class="constrain small" />

### Machine Setup

Our data is now ready to be fed to the machine. This video documents the machine setup with [Karsten](https://www.hochschule-rhein-waal.de/en/faculties/communication-and-environment/organisation/professors/prof-dr-karsten-nebe) from the [FabLab Kamp Lintfort](http://fablab.hochschule-rhein-waal.de/index.php/en/):

<iframe width="560" height="315" src="https://www.youtube.com/embed/PtMkJkBU450" frameborder="0" allowfullscreen class="constrain"></iframe>

### Test Joint

When the machine is set up, we mill a test joint in order check and adjust for the material properties.

<iframe width="560" height="315" src="https://www.youtube.com/embed/ZpRVwqPG5-I" frameborder="0" allowfullscreen class="constrain"></iframe>

<div class="row">
	<div class="col-sm-6"><img src="10-joint-test-1.jpg" class="constrain shadow" /></div>
	<div class="col-sm-6"><img src="11-joint-test-2.jpg" class="constrain shadow" /></div>
</div>

The joint looks great, it just fits a tiny bit too tightly. But the error is so small, we're gonna leave if for now. Later I find out that i have to sand each joint in order to make them slip a bit easier.

### Let the mills grind

Now that the joint looks good, we can run the two remaining jobs for the actual *Outside* and *Inside Cuts*. Instead of showing you another boring video, you'll just get a snapshot of the result. Search youtube for "cnc milling wood" if you want to watch machines at work.

<div class="row">
	<div class="col-sm-6"><img src="12-cutting-almost-done.jpg" class="constrain shadow" /></div>
	<div class="col-sm-6"><img src="13-cutting-done.jpg" class="constrain shadow" /></div>
</div>

### Finishing

After the cutting we notice that our parts have fringed edges. This is especially obvious for cuts perpendicular to the grain of the top wood layer. Cuts that went parallel to the grain look quite smooth:

<img src="14-fizzy-edges.jpg" class="constrain shadow" />

We use sand paper to clean all edges on all our parts:

<div class="row">
	<div class="col-sm-4">
		<img src="15-sanding-before.jpg" class="constrain shadow" />
		<span class="img-caption">Before sanding</span>
	</div>
	<div class="col-sm-4">
		<img src="16-sanding-after.jpg" class="constrain shadow" />
		<span class="img-caption">After sanding</span>
	</div>
	<div class="col-sm-4">
		<img src="17-sanding.jpg" class="constrain shadow" />
		<span class="img-caption">Also the tiny parts ;)</span>
	</div>
</div>


## Assembly

<img src="18-assembly-0.jpg" class="constrain shadow" />

<div class="row">
	<div class="col-sm-6">
		<img src="19-assembly-1.jpg" class="constrain shadow" />
	</div>
	<div class="col-sm-6">
		<img src="20-assembly-2.jpg" class="constrain shadow" />
	</div>
</div>

<div class="row">
	<div class="col-sm-6">
		<img src="21-assembly-3.jpg" class="constrain shadow" />
	</div>
	<div class="col-sm-6">
		<img src="22-assembly-4.jpg" class="constrain shadow" />
	</div>
</div>

<div class="row">
	<div class="col-sm-6">
		<img src="23-assembly-5.jpg" class="constrain shadow" />
	</div>
	<div class="col-sm-6">
		<img src="24-finished-outside.jpg" class="constrain shadow" />
	</div>
</div>
