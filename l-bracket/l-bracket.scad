//=============================================================================
// l-bracket.scad
//
// generates an l-bracket from the given parameters
//=============================================================================
// Written in 2015 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

wall_thickness = 2;
internal_width = 12;
slot_width = 4;
side_length = 20;

// customizable variables end here

head_annulus = (internal_width/2) - (slot_width/2);

abit = 0.0001 * 1; //use for making overlap to get single manifold stl

module stadium3d(a, r, z, center = false){
	offset_x = center ? -(r + (a / 2)) : 0;
	offset_y = center ? -(r) : 0;
	offset_z = center ? -(z / 2) : 0;

	translate([offset_x, offset_y, offset_z])
	union() {
		translate([r, 0, 0])
			cube([a, 2*r, z]);
		translate([r, r, 0])
			cylinder(h = z, r = r, center = false);
		translate([r + a, r, 0])
			cylinder(h = z, r = r);
	}
}

union() {
	// horizontal wall
	difference() {
		cube([side_length + wall_thickness,
		      internal_width + 2*wall_thickness,
		      wall_thickness]);
		translate([wall_thickness + head_annulus,
		           wall_thickness + head_annulus,
		           -1])
			stadium3d(side_length - (2*head_annulus) - slot_width,
 			          slot_width / 2,
 			          wall_thickness + 2);
	}

	// verticle wall
	translate([wall_thickness, 0, 0])
	rotate([0,-90,0])
	difference() {
		cube([side_length + wall_thickness,
		      internal_width + 2*wall_thickness,
		      wall_thickness]);
		translate([wall_thickness + head_annulus,
		           wall_thickness + head_annulus,
		           -1])
			stadium3d(side_length - (2*head_annulus) - slot_width,
 			          slot_width / 2,
 			          wall_thickness + 2);
	}

	// bracer 1
	translate([wall_thickness - abit,
	           wall_thickness,
	           wall_thickness - abit])
	rotate([90,0,0])
	linear_extrude(height = wall_thickness) {
		polygon([[0,0],
		        [side_length,0],
		        [0,side_length]]);
	}

	// bracer 2
	translate([wall_thickness - abit,
	           2*wall_thickness + internal_width,
	           wall_thickness - abit])
	rotate([90,0,0])
	linear_extrude(height = wall_thickness) {
		polygon([[0,0],
		        [side_length,0],
		        [0,side_length]]);
	}
}
