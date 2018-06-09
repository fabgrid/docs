use <linear-actuator.scad>;
include <variables.scad>;

module YAxis(position = 0) {
    rotate([0, 0, 90])
        LinearActuator(Y_AXIS_LENGTH, position, "left");
}

YAxis();
