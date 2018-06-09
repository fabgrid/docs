/**
 * The range at the end of each axis that the gantry cannot reach.
 * @type {Number}
 */
AXIS_END_OFFSET = 40;

/**
 * Lengths of the extrusions for each axis.
 */
X_AXIS_LENGTH = 500;
Y_AXIS_LENGTH = 500;

X_AXIS_LENGTH_EFFECTIVE = X_AXIS_LENGTH - 2*AXIS_END_OFFSET;
Y_AXIS_LENGTH_EFFECTIVE = Y_AXIS_LENGTH - 2*AXIS_END_OFFSET;
