use <MCAD/servos.scad>;
include <variables.scad>;

$fn = 60;

THICKNESS = 3;
CORNER_RADIUS = 3;

BASE_WIDTH = 60;
BASE_HEIGHT = 60;

BASE_HOLES = [
    // [translation, diameter]
    // Servo shaft
    [[40, 0, -8], 15],

    // Servo mounting screws
    [[54.5, 0, -3], 4],
    [[54.5, 0, -13], 4],
    [[6, 0, -3], 4],
    [[6, 0, -13], 4],

    // Gantry plate interface
    [[BASE_WIDTH/2, 0, 17], 5],
    [[BASE_WIDTH/2, 0, 27], 5],
    [[BASE_WIDTH/2, 0, 37], 5],
    [[BASE_WIDTH/2 - 10, 0, 27], 5],
    [[BASE_WIDTH/2 + 10, 0, 27], 5],
];

BEARING_LENGTH = 24;
BEARING_DIAMETER = 15;
BEARING_SLOT = 8;

RAIL_LENGTH = 75;
RAIL_DIAMETER = 8.5;  // including tolerance
RAIL_SPACING = BASE_WIDTH - BEARING_DIAMETER - THICKNESS;

PEN_DIAMETER = 15;  // larger than needed, can be fixed with rubber bands

POSITION_OFFSET = 13;

module _BearingHousing () {
    outer_diameter = BEARING_DIAMETER + THICKNESS;

    translate([0, -outer_diameter/2, 0])
    difference() {
        union() {
            translate([outer_diameter/2, 0, 0])
                cylinder(d = outer_diameter, h = BEARING_LENGTH);
            cube([outer_diameter, outer_diameter/2, BEARING_LENGTH]);
        }

        translate([outer_diameter/2, 0, 0])
            cylinder(d = BEARING_DIAMETER, h = BEARING_LENGTH);

        translate([(outer_diameter-BEARING_SLOT)/2, -outer_diameter+THICKNESS*2, 0])
            cube([BEARING_SLOT, THICKNESS*2, BEARING_LENGTH]);
    }
}

module _BaseHoles() {
    for (hole = BASE_HOLES) {
        translation = hole[0];
        diameter = hole[1];

        translate(translation + [0, -1, 0])
        rotate([270, 0, 0])
            cylinder(d = diameter, h = THICKNESS + 2);
    }
}

module _BasePlate(servo = false) {
    difference() {
        union() {
            // Base plate
            translate([CORNER_RADIUS, 0, -18 + CORNER_RADIUS])
                minkowski() {
                    cube([BASE_WIDTH - 2*CORNER_RADIUS, THICKNESS/2, BASE_HEIGHT - 2*CORNER_RADIUS]);
                    translate([0, THICKNESS/2, 0])
                    rotate([90, 0, 0])
                        cylinder(r = CORNER_RADIUS, h = THICKNESS/2);
                }

            // Bearing housings
            _BearingHousing();
            translate([BASE_WIDTH - BEARING_DIAMETER - THICKNESS, 0, 0])
                _BearingHousing();
        }

        _BaseHoles();
    }

    if (servo) {
        futabas3003([10, 39, 2], [90, 90, 0]);
    }
}

module _Rails(end_length) {
    translate([(BEARING_DIAMETER+THICKNESS)/2, -(BEARING_DIAMETER+THICKNESS)/2, -end_length]) {
        cylinder(h = RAIL_LENGTH, d = RAIL_DIAMETER);
        translate([RAIL_SPACING, 0, 0])
            cylinder(h = RAIL_LENGTH, d = RAIL_DIAMETER);
    }
}

module _CarriageEnd(depth) {
    translate([(BEARING_DIAMETER+THICKNESS)/2, -(BEARING_DIAMETER+depth+THICKNESS)/2, -depth])
    difference() {
        union() {
            cube([RAIL_SPACING, depth, depth]);
            translate([0, depth/2, 0])
                cylinder(d = depth, h = depth);
            translate([RAIL_SPACING, depth/2, 0])
                cylinder(d = depth, h = depth);
        }
        translate([0, depth/2])
            cylinder(d = RAIL_DIAMETER, h = depth);
        translate([RAIL_SPACING, depth/2])
            cylinder(d = RAIL_DIAMETER, h = depth);
    }
}

module _PenCarriage(end_length) {
    union() {
        _CarriageEnd(end_length);
        translate([(BEARING_DIAMETER+THICKNESS+RAIL_SPACING)/2, -end_length - PEN_DIAMETER/2 - THICKNESS, -end_length])
            difference() {
                cylinder(d = PEN_DIAMETER + 2*THICKNESS, h = end_length);
                cylinder(d = PEN_DIAMETER, h = end_length);
                // translate([-PEN_DIAMETER/2 - THICKNESS, -PEN_DIAMETER, 0])
                //     cube([PEN_DIAMETER+2*THICKNESS, PEN_DIAMETER, end_length]);
            }
    }
}

module _Carriage() {
    end_length = RAIL_DIAMETER + 2*THICKNESS;

    _Rails(end_length);
    _PenCarriage(end_length);
    translate([0, 0, RAIL_LENGTH])
        _PenCarriage(end_length);
}

module EndEffector(position = 0) {
    _BasePlate(servo = true);
    translate([0, 0, -POSITION_OFFSET - position])
        _Carriage(position);
}

// EndEffector(0);
_PenCarriage(RAIL_DIAMETER + 2*THICKNESS);
// _BasePlate();
