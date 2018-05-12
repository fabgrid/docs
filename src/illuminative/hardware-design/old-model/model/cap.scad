include <_variables.scad>;


module cap(outer_length = CAP_OUTER_LENGTH)
{
	difference() {
		union() {
			cylinder(d = INNER_DIAMETER, h = CAP_INNER_LENGTH);
			translate([0, 0, CAP_INNER_LENGTH])
				cylinder(d = DIAMETER, h = outer_length);
		}
		linear_extrude(height = CAP_INNER_LENGTH)
			import(file = HEATSINK_SHAPE);
	}
}

cap();
