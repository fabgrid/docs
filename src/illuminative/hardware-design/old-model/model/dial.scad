include <_variables.scad>;


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

dial();
