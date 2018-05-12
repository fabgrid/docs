// Length of the lamp shade
LENGTH = 120;
// Outer diameter of the lamp in general
DIAMETER = 50;
// Material strength
RIM = 2;

$fn=50;

// Thickness of the heatsink copper material
HEATSINK_THICKNESS = 1;
// Source file (DXF) of the 2D profile of the heat sink
HEATSINK_SHAPE = "heatsink-shape.dxf";
// Material thickness of the shade
SHADE_THICKNESS = 2;
// CALCULATED: Inner diameter of the lamp shade
INNER_DIAMETER = DIAMETER - 2*SHADE_THICKNESS;

// Thickness (along the axis of the lamp) of the encoder dial
DIAL_THICKNESS = 10;
// Number of teeth on the encoder dial
DIAL_TEETH = 240;
// Depth of each tooth on the encoder dial
DIAL_TEETH_DEPTH = 1;
// CALCULATED: Angle between two neightbouring teeth on the encoder dial
DIAL_TEETH_ANGLE = 360/DIAL_TEETH;

// Source file of the 2D outline of the pcb
PCB_OUTLINE = "./../electronics-design/board-outline.dxf";
// Total thickness of all PCBs with components
PCB_THICKNESS = 10;

// Length (along axis of the lamp) of the "passive" end cap, outside the lamp shade
CAP_OUTER_LENGTH =  5;
// Length (along axis of the lamp) of the "passive" end cap, inside the lamp shade
CAP_INNER_LENGTH = 5;

// Diameter of the hole that the power jack needs in order to protrude through the case
JACK_DRILL_DIAMETER = 5;
// Maximum diameter of that part of the power jack that will be inside the lamp casing
JACK_MAX_DIAMETER = 7;
// Length of that part of the power jack that will be inside the lamp casing
JACK_INNER_LENGTH = 2;
