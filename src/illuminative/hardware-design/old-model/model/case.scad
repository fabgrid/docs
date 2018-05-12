include <_variables.scad>;
use <cap.scad>;


module case()
{
	outer_length = PCB_THICKNESS + 2*RIM;
	jack_outer_lenght = JACK_MAX_DIAMETER + 2*RIM;

	difference() {
		union() {
			difference() {
				cap(outer_length);

				// Space for the pcb to fit in
				translate([0, 0, CAP_INNER_LENGTH + RIM])
					cylinder(d = INNER_DIAMETER, h = outer_length);

				// A hole where the cables pass through to the LEDs
				translate([0, 17, 0])
					cylinder(d = 3, h = outer_length + CAP_INNER_LENGTH);
			}

			// A box for the power jack
			translate([0, (DIAMETER+JACK_INNER_LENGTH)/2, jack_outer_lenght/2 + CAP_INNER_LENGTH])
				cube([jack_outer_lenght, JACK_INNER_LENGTH + RIM, jack_outer_lenght], center=true);
		}

		// A hole for the power jack inside that box
		translate([0, (JACK_INNER_LENGTH+DIAMETER)/2-RIM, JACK_MAX_DIAMETER/2 + CAP_INNER_LENGTH + RIM])
			#cube([JACK_MAX_DIAMETER, JACK_INNER_LENGTH+RIM, JACK_MAX_DIAMETER], center=true);

		// translate([0, DIAMETER/2 + RIM + JACK_INNER_LENGTH - 1, CAP_INNER_LENGTH + JACK_MAX_DIAMETER/2 + RIM])
		// rotate([90, 0, 0])
		// 	cylinder(d = JACK_DRILL_DIAMETER, h = RIM+2);
	}

}

case();
