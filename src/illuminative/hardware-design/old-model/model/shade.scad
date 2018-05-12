include <_variables.scad>;


module shade()
{
	difference() {
		cylinder(d = DIAMETER, h = LENGTH);
		translate([0, 0, -1])
		cylinder(d = INNER_DIAMETER, h = LENGTH + 2);
	}
}

shade();
