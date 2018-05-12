$fn = 60;

// Outer diameter of the dial
DIAL_DIAMETER = 50;
// Thickness (along the axis of the lamp) of the encoder dial
DIAL_THICKNESS = 8;
// Number of teeth on the encoder dial
DIAL_TEETH = 120;
// Depth of each tooth on the encoder dial
DIAL_TEETH_DEPTH = 2;
// CALCULATED: Angle between two neightbouring teeth on the encoder dial
DIAL_TEETH_ANGLE = 360/DIAL_TEETH;
// Diameter of the center hole
DIAL_CENTER_HOLE_DIA = 6;

MARGIN = 10;
OUTER_X_Y = DIAL_DIAMETER + 2*MARGIN;
OUTER_Z = DIAL_THICKNESS + MARGIN;

CAST_ON_DIA_1 = 2;
CAST_ON_DIA_2 = 6;

module dial()
{
    difference() {
        cylinder(d = DIAL_DIAMETER, h = DIAL_THICKNESS);
        for(a = [0 : DIAL_TEETH]) {
            rotate([0, 0, DIAL_TEETH_ANGLE * a])
            translate([-DIAL_DIAMETER/2, 0, -1])
                cylinder(d = DIAL_TEETH_DEPTH, $fn=3, h = DIAL_THICKNESS + 2);
        }
        translate([0, 0, -1])
            cylinder(d = DIAL_CENTER_HOLE_DIA, h = DIAL_THICKNESS + 2);
    }
}

module castOns() {
    for(o = [-1, 1]) {
        translate([o * DIAL_DIAMETER/3, 0, DIAL_THICKNESS - 0.1])
            cylinder(d1 = CAST_ON_DIA_1, d2 = CAST_ON_DIA_2, h = MARGIN + 0.2);
    }
}

union() {
    dial();
    castOns();
}

