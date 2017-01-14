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
body_depth = 2;

wall_thickness = 2;

fogger_width = 45;
fogger_height = 30;

water_depth = 20;

// customizable variables end here

basket_depth = fogger_height + water_depth;

abit = 0.001; //use for making overlap to get single manifold stl
alot = 1000;

$fa = 1;

module fogger_holder() {
    difference() {
        translate([0,0,-(basket_depth+wall_thickness+abit)])
        cylinder(h = basket_depth, d = fogger_width + (wall_thickness * 2));
    
        translate([0,0,-basket_depth + abit])
        cylinder(h = basket_depth, d = fogger_width);
    
        translate([0,0,-alot/2])
        cylinder(h = alot, d = fogger_width*0.9);
    }
}

difference() {
    union() {
        difference() {
            // main body
            cylinder(h = wall_thickness, d = body_diameter);
            
            // fogger holes
            rotate([0,0,360 * 1/3])
            translate([30,0,-alot/2])
                cylinder(h = alot, d = 45);
            
            rotate([0,0,360 * 2/3])
            translate([30,0,-alot/2])
                cylinder(h = alot, d = 45);
            
            rotate([0,0,360 * 3/3])
            translate([30,0,-alot/2])
                cylinder(h = alot, d = 45);
        }
        
        rotate([0,0,360 * 1/3])
        translate([30,0,wall_thickness-abit])
            fogger_holder();

        rotate([0,0,360 * 2/3])
        translate([30,0,wall_thickness-abit])
            fogger_holder();
        
        rotate([0,0,360 * 3/3])
        translate([30,0,wall_thickness-abit])
            fogger_holder();
    }

    difference() {
        translate([0,0,-alot/2])
        cylinder(h = alot, d = alot);
        
        translate([0,0,-alot/2])
        cylinder(h = alot, d = 90);
    }
    
    translate([0,0,-alot/2])
    cylinder(h = alot, d = 5);
}
