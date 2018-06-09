use <linear-actuator.scad>;
include <variables.scad>;

module XAxis(position = 0) {
    rotate([90, 0, 0])
        LinearActuator(Y_AXIS_LENGTH, position, "right");
}
