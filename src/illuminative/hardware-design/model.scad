
use <MCAD/gears.scad>

LENGTH = 120;
DIAMETER = 60;
RIM = 5;

HEATSINK_THICKNESS = 1;
SHADE_THICKNESS = 1;

ENCODER_FIXTURE_WIDTH = 15;
ENCODER_CUTOUT_DEPTH = 15;
ENCODER_FIXTURE_ANGLE = 35;
ENCODER_BORE_DIAMETER = 10;

DIAL_THICKNESS = 10;
DIAL_TEETH = 240;
DIAL_TEETH_DEPTH = 1;
DIAL_TEETH_ANGLE = 360/DIAL_TEETH;

$fn = 60;

module heatsink()
{
	translate([0, 0, -HEATSINK_THICKNESS])
	union() {
		difference() {
			// Base heatsink sheet
			cube([DIAMETER, LENGTH, HEATSINK_THICKNESS]);

			// Cutout
			translate([(DIAMETER - ENCODER_FIXTURE_WIDTH)/2, LENGTH - ENCODER_CUTOUT_DEPTH + 0.001, -0.001])
			cube([ENCODER_FIXTURE_WIDTH, ENCODER_CUTOUT_DEPTH, HEATSINK_THICKNESS + 0.002]);

		}
			// Encoder fixture
			fixture_lower_length = ENCODER_CUTOUT_DEPTH/cos(ENCODER_FIXTURE_ANGLE);
			fixture_upper_length = 2*ENCODER_CUTOUT_DEPTH*tan(ENCODER_FIXTURE_ANGLE);
			fixture_total_length = fixture_lower_length + fixture_upper_length;
			echo(fixture_cutout_depth = ENCODER_CUTOUT_DEPTH);
			echo(fixture_total_length = fixture_total_length);
			echo(fixture_protrusion = fixture_total_length - ENCODER_CUTOUT_DEPTH);
			union() {
				translate([(DIAMETER - ENCODER_FIXTURE_WIDTH)/2, LENGTH - ENCODER_CUTOUT_DEPTH, 0])
				rotate([ENCODER_FIXTURE_ANGLE, 0, 0])
				cube([ENCODER_CUTOUT_DEPTH, fixture_lower_length, HEATSINK_THICKNESS]);

				translate([(DIAMETER - ENCODER_FIXTURE_WIDTH)/2, LENGTH - HEATSINK_THICKNESS, -fixture_upper_length/2])
				difference() {
					cube([ENCODER_FIXTURE_WIDTH, HEATSINK_THICKNESS, fixture_upper_length]);
					translate([ENCODER_FIXTURE_WIDTH/2, HEATSINK_THICKNESS*1.5, fixture_upper_length/2])
					rotate([90, 0, 0])
					cylinder(d = ENCODER_BORE_DIAMETER, h = HEATSINK_THICKNESS*2);
				}
			}
	}

}

module cover()
{
	translate([0, 0, -HEATSINK_THICKNESS/2])
	union() {
		// Tube
		difference() {
			translate([DIAMETER/2, LENGTH, 0])
			rotate([90, 0, 0])
			difference() {
				cylinder(d = DIAMETER, h = LENGTH);
				translate([0, 0, -0.001])
				cylinder(d = DIAMETER - 2*SHADE_THICKNESS, h = LENGTH+0.002);
			}
			translate([0, -0.001, -DIAMETER/2])
			cube([DIAMETER, LENGTH+0.002, DIAMETER/2+HEATSINK_THICKNESS/2]);
		}
		// Rim
		translate([SHADE_THICKNESS/2, 0, HEATSINK_THICKNESS/2])
		cube([RIM, LENGTH, SHADE_THICKNESS]);
		translate([DIAMETER - RIM - SHADE_THICKNESS/2, 0, HEATSINK_THICKNESS/2])
		cube([RIM, LENGTH, SHADE_THICKNESS]);
	}
}

module covers()
{
	// Upper Cover
	cover();

	// Lower Cover
	translate([DIAMETER, 0, -HEATSINK_THICKNESS])
	rotate([0, 180, 0])
	cover();
}

module dial()
{
	translate([DIAMETER/2, LENGTH + DIAL_THICKNESS, -HEATSINK_THICKNESS/2])
	rotate([90, 0, 0])
	difference() {
		cylinder(d = DIAMETER, h = DIAL_THICKNESS);
		for(a = [0 : DIAL_TEETH]) {
			rotate([0, 0, DIAL_TEETH_ANGLE * a])
			translate([-DIAMETER/2, 0, -0.001])
			cylinder(d = DIAL_TEETH_DEPTH, $fn=3, h = DIAL_THICKNESS + 0.002);
		}
	}
}

module shade_mold_outer()
{
	wall_thickness = 10;
	width = DIAMETER + 2*wall_thickness;
	length = LENGTH + 2*wall_thickness;
	height = width/2;
	difference() {
		cube([width, length, height]);
		translate([width/2, length, width/2])
		rotate([90, 0, 0])
			cylinder(h=length, d=DIAMETER);
	}
	echo(width = width);
	echo(height = height);
	echo(length = length);
}

module shade_mold_inner()
{
	wall_thickness = 10;
	length = LENGTH + 2*wall_thickness;
	diameter = DIAMETER - 2*SHADE_THICKNESS;
	difference() {
		translate([diameter/2, length, 0])
		rotate([90, 0, 0])
			cylinder(h=length, d=diameter);
		translate([0, 0, -diameter])
			#cube([diameter, length, diameter]);
	}
}

// Copper Base
color("PeachPuff")
heatsink();

// Covers
color("Gray", 0.8)
covers();

// Encoder Dial
color("DimGray")
dial();

// shade_mold_outer();
// shade_mold_inner();
