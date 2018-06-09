include <MCAD/stepper.scad>;
use <openscad-openbuilds/library.scad>;
use <v-slot-end-mount.scad>;
include <variables.scad>;

/**
 * An axis including motor & mount.
 *
 * @param {Number} length The length of the extrusion (effective length with end caps is longer)
 */
module LinearActuator(length = 500, position = 0, motor_position = "left") {
    motor_rotation = motor_position == "left" ? [270, 0, 0] : [90, 0, 0];
    motor_translation = motor_position == "left" ? [-19.5, 13, 10] : [-19.5, -13, 10];
    pulley_rotation = motor_position == "left" ? [90, 0, 0] : [270, 0, 0];
    pulley_translation = motor_position == "left" ? [-19.5, 10, 10] : [-19.5, -10, 10];

    // The extrusion
    rotate([90, 90, 90])
        vslot20x40(length);

    // The motor end
    VSlotEndMount();

    translate(motor_translation)
    rotate(motor_rotation)
        motor(Nema17);

    translate(pulley_translation)
    rotate(pulley_rotation)
        timing_pulley_gt2_30();

    // The idler end
    translate([length, 0, 0]) {
        rotate([0, 0, 180])
            VSlotEndMount();

        translate([19.5, 10, 10])
        rotate([90, 90, 0])
            timing_pulley_gt2_30();
    }

    // The gantry
    translate([position + AXIS_END_OFFSET, -25, 22])
        Gantry();
}

/**
 * The moving part of the actuator.
 */
module Gantry() {
    mini_v_gantry_plate();
}

LinearActuator();
