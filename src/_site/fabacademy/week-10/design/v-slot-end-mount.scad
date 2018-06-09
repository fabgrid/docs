/**
 * End mount for NEMA-17 stepper motors on
 * OpenBuilds V-Slot linear extrusions.
 */


RAIL_WIDTH = 20.5;  // incl tolerance
CORNER_RADIUS = 4;
THICKNESS = 3;
$fn = 30;

SIDE_LENGTH = 83;
SIDE_LENGTH_HI = 47;
SIDE_LENGTH_LO = SIDE_LENGTH - SIDE_LENGTH_HI;
SIDE_HEIGHT_HI = 54.9;
SIDE_HEIGHT_LO = 39.9;

SHAFT_CENTER = [59.5, SIDE_HEIGHT_HI - 25];
SHAFT_DIAMETER = 6;
SHAFT_SCREW_OFFSET = 15.5;  // per axis
MOTOR_SCREW_DIAMETER = 3.6;
MOTOR_FLANGE_DIAMETER = 22;
MOTOR_FLANGE_DEPTH = 2;

RAIL_SCREW_DIAMETER = 5;
RAIL_SCREW_OFFSET = 20;  // per axis
RAIL_SCREW_LOWER_X = 8;
RAIL_SCREW_LOWER_Y = 11;
RAIL_SCREW_UPPER_Y = RAIL_SCREW_LOWER_Y + RAIL_SCREW_OFFSET;

/**
 * A square with rounded corners.
 *
 * @param {Vector[2]} size
 * @param {Number} radius_corner
 */
module RoundedSquare( size, radius_corner ) {
    translate([ radius_corner, radius_corner, 0 ])
        minkowski() {
            square([size[0] - 2*radius_corner, size[1] - 2*radius_corner]);
            circle(radius_corner);
        }
}

/**
 * 2D version of one side of the bracket.
 */
module Side2d()
{
    difference() {
        // Just the outer shape of the side
        translate([0, -THICKNESS])
        union() {
            RoundedSquare([SIDE_LENGTH, SIDE_HEIGHT_LO + THICKNESS], CORNER_RADIUS);
            translate([SIDE_LENGTH_LO, 0])
                RoundedSquare([SIDE_LENGTH_HI + THICKNESS, SIDE_HEIGHT_HI + THICKNESS], CORNER_RADIUS);
        }

        // The shaft
        translate(SHAFT_CENTER)
            circle(d=SHAFT_DIAMETER);

        // Four holes for the motor screws
        for (x = [-1 : 2 : 1]) {
            for (y = [-1 : 2 : 1]) {
                translate(SHAFT_CENTER + [x*SHAFT_SCREW_OFFSET, y*SHAFT_SCREW_OFFSET])
                    circle(d=MOTOR_SCREW_DIAMETER);
            }
        }

        // Four hole for fixture to the extrusions
        for (x = [0 : 1]) {
            for (y = [0 : 1]) {
                translate([RAIL_SCREW_LOWER_X + x*RAIL_SCREW_OFFSET, RAIL_SCREW_LOWER_Y + y*RAIL_SCREW_OFFSET])
                    circle(d=RAIL_SCREW_DIAMETER);
            }
        }
    }
}

module Block()
{
    difference() {
        linear_extrude(height=RAIL_WIDTH + 2*THICKNESS)
            Side2d();
        translate(SHAFT_CENTER) {
            cylinder(h = MOTOR_FLANGE_DEPTH, d2 = MOTOR_FLANGE_DIAMETER * 1.05, d1 = MOTOR_FLANGE_DIAMETER * 1.15);
            translate([0, 0, RAIL_WIDTH + 2*THICKNESS - MOTOR_FLANGE_DEPTH])
                cylinder(h = MOTOR_FLANGE_DEPTH, d1 = MOTOR_FLANGE_DIAMETER * 1.05, d2 = MOTOR_FLANGE_DIAMETER * 1.15);
        }
    }
}

module VSlotEndMount()
{
    color("DimGray")
    rotate([-90, 180, 0])
    translate([-2*RAIL_WIDTH, -RAIL_WIDTH, -RAIL_WIDTH/2])
        difference() {
            translate([0, 0, -THICKNESS])
            Block();

            // The "rail"
            cube([SIDE_LENGTH, SIDE_HEIGHT_HI, RAIL_WIDTH]);
        }
}

module SingleSide()
{
    translate([0, 0, -RAIL_WIDTH - THICKNESS])
    difference() {
        Block();
        translate([0, -THICKNESS, 0])
            cube([SIDE_LENGTH + THICKNESS, SIDE_HEIGHT_HI + THICKNESS, RAIL_WIDTH + THICKNESS]);
    }
}

// VSlotEndMount();
SingleSide();
