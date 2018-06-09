$fn = 30;

// Outer diameter of the dial
DIAL_DIAMETER = 50;
// Thickness (along the axis of the lamp) of the encoder dial
DIAL_THICKNESS = 6;
// Number of teeth on the encoder dial
DIAL_TEETH = 120;
// Depth of each tooth on the encoder dial
DIAL_TEETH_DEPTH = 2;
// CALCULATED: Angle between two neightbouring teeth on the encoder dial
DIAL_TEETH_ANGLE = 360/DIAL_TEETH;
// Diameter of the center hole
DIAL_CENTER_HOLE_DIA = 6;

MARGIN = 4;
OUTER_X_Y = DIAL_DIAMETER + 2*MARGIN;
OUTER_Z = DIAL_THICKNESS + 2*MARGIN;

CAST_ON_DIA_1 = 2;
CAST_ON_DIA_2 = 6;

ALIGNMENT_POST_DIA = 6;

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

module outerSolid() {
    translate([-OUTER_X_Y/2, -OUTER_X_Y/2, -MARGIN])
        cube([OUTER_X_Y, OUTER_X_Y, OUTER_Z]);
}

module alignmentPosts(offset) {
    xyOffset = OUTER_X_Y/2 - ALIGNMENT_POST_DIA;
    for (o = [xyOffset, -xyOffset]) {
        translate([o, o, -DIAL_THICKNESS/4])
            cylinder(d1 = ALIGNMENT_POST_DIA+1, d2 = ALIGNMENT_POST_DIA-1 + offset, h = OUTER_Z * .8);
    }
}

module mold(part) {
    // If the "top" half is requested, subtract away the lower part, vice versa
    subtractionZPlane = part == "top" ? -OUTER_Z + DIAL_THICKNESS/2 - 1 : DIAL_THICKNESS/2;

    union() {
        difference() {
            difference() {
                difference() {
                    outerSolid();
                    dial();
                }
                castOns();
            }
            translate([-OUTER_X_Y/2 - 1, -OUTER_X_Y/2 - 1, subtractionZPlane])
                cube([OUTER_X_Y + 2, OUTER_X_Y + 2, OUTER_Z + 1]);
        }
    }
}

module top() {
    difference() {
        mold("top");
        alignmentPosts(0.05);
    }
}

module bottom() {
    union() {
        mold("bottom");
        alignmentPosts(-0.05);
    }
}

// bottom();
top();
