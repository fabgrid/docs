/**
 * Design files for a pen plotter built using the OpenBuilds V-Carve rails.
 *
 * Author: Joseph Paul
 * License: WTFPL
 */

use <x-axis.scad>;
use <y-axis.scad>;
include <variables.scad>;

Y = 100;
X = 0;

// Y Axis
YAxis(position = Y);

// X Axis
translate([-20, Y + AXIS_END_OFFSET + 23.5, 41])
    XAxis(position = X);
