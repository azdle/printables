//=============================================================================
// Floater.scad
//
// Holder for ultrasonic foggers, makes them float at the proper depth in a
// larger container of water.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

body_diameter = 120;
body_depth = 20;

wall_thickness = 4;

fogger_width = 45;
fogger_height = 30;

water_depth = 20;

// customizable variables end here

basket_depth = fogger_height + water_depth;

abit = 0.0001; //use for making overlap to get single manifold stl
alot = 10000;

module fogger_slot() {
    difference() {
        union() {
            // tangent support
            translate([0, 0, -(basket_depth/2 + wall_thickness)])
            cube([wall_thickness,
                  fogger_width + wall_thickness*2,
                  basket_depth + wall_thickness],
                 center = true);
            
            // radial support
            rotate([0,0,360 * 1/4])
            translate([0, 0, -(basket_depth/2 + wall_thickness)])
            cube([wall_thickness,
                  fogger_width + wall_thickness*2,
                  basket_depth + wall_thickness],
                 center = true);
            
            translate([0,0,-(body_depth+abit)])
            cylinder(h = body_depth, d = fogger_width + (wall_thickness * 2));
        }
    
        translate([0,0,-basket_depth + abit])
        cylinder(h = basket_depth, d = fogger_width);
    }
}

union() {
	// main body
	difference() {
		cylinder(h = body_depth, d = body_diameter);
        
		translate([0,0,-wall_thickness])
			cylinder(h = body_depth, d = body_diameter - wall_thickness*2);
        
        rotate([0,0,360* 1/3])
        translate([30,0,-alot/2])
            cylinder(h = alot, d = 45);
        
        rotate([0,0,360* 2/3])
        translate([30,0,-alot/2])
            cylinder(h = alot, d = 45);
        
        rotate([0,0,360* 3/3])
        translate([30,0,-alot/2])
            cylinder(h = alot, d = 45);
	}
    
    rotate([0,0,360* 1/3])
    translate([30,0,body_depth])
        fogger_slot();

    rotate([0,0,360* 2/3])
    translate([30,0,body_depth])
        fogger_slot();
    
    rotate([0,0,360* 3/3])
    translate([30,0,body_depth])
        fogger_slot();
}
