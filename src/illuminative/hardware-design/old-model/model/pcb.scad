include <_variables.scad>;


module pcb()
{
	linear_extrude(height = PCB_THICKNESS, center = true, convexity = 10)
		import (file = PCB_OUTLINE);
}

pcb();
