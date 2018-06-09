$fs=15;
increment=3;  // degrees
range=180;    // degrees
thickness=7;
base_size=100;

module hollowCube(edge_length, thickness)
{
	inner_length = edge_length - thickness;
	difference() {
		cube([edge_length,edge_length,edge_length], center=true);
		cube([inner_length,inner_length,inner_length], center=true);
		cylinder(h=edge_length+1, d=inner_length, center=true);
		rotate([90, 0, 0])
			cylinder(h=edge_length+1, d=inner_length, center=true);
		rotate([0, 90, 0])
			cylinder(h=edge_length+1, d=inner_length, center=true);
	}
}

difference() {
	union() {
		for	(i = [0:increment:range]) {
			size=base_size*(i/range);
			rotate([i, i, 0])
				hollowCube(size, thickness);
		}
	}
	// translate([-base_size,-base_size,0])
	// 	cube(size=base_size*2);
}
