include <_variables.scad>;


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
	diameter = INNER_DIAMETER;
	difference() {
		translate([diameter/2, length, 0])
		rotate([90, 0, 0])
			cylinder(h=length, d=diameter);
		translate([0, 0, -diameter])
			#cube([diameter, length, diameter]);
	}
}

shade_mold_inner();
// shade_mold_outer();
