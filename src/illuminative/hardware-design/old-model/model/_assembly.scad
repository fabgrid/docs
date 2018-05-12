include <_variables.scad>;
use <cap.scad>;
use <case.scad>;
use <dial.scad>;
use <heatsink.scad>;
use <pcb.scad>;
use <shade.scad>;

$fn=360;


// Copper Heatsink
color("PeachPuff")
heatsink();

// Shade
color("PaleTurquoise", 0.5)
shade();

// Encoder Dial
color("DimGray")
dial();

// Cap
color("DimGray")
cap();

// Case holding the electronics
color("DimGray")
case();
