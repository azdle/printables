//=============================================================================
// battery-tower.scad
//
// A simple container for holding batteries with a slot down the side to make
// it easier to remove them later.
//=============================================================================
// Written in 2018 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

//=============================================================================
// dimensions
//=============================================================================

wall = 4;

// default: AA sized
batt_d = 14.5;
batt_h = 50.5;

cavity_count_h = 15; // # of batteries tall
cavity_count_l = 5; // # of battries long (deep)
cavity_count_w = 1; // # of battries wide

slot_proportion = 1/2;

cavity_h = cavity_count_h * batt_d;
cavity_l = cavity_count_l * batt_d;
cavity_w = cavity_count_w * batt_h;
cavity_r = batt_d/2;

body_h = cavity_h + wall;
body_l = cavity_l + 2*wall;
body_w = cavity_w + 2*wall;
body_r = cavity_r + wall;

slot_w = batt_h * slot_proportion;

$fn = 150;

abit = 0.05;
alot = 1000;

//=============================================================================
// modules
//=============================================================================

module rounded_rect_3d(dim, r) {
    x = dim[2];
    y = dim[1];
    z = dim[0];
    
    // limit diameter to half of x or y
    rl = r > x/2 ? x/2 : (r > y/2 ? y/2 : r);
    
    rotate([0,90,0])
    translate([-x, 0, 0])
    hull() {
        translate([rl, rl, 0])
        cylinder(r = rl, h = z);
        
        translate([x-rl, rl, 0])
        cylinder(r = rl, h = z);
        
        translate([x-rl, y-rl, 0])
        cylinder(r = rl, h = z);
        
        translate([rl/2, y-rl, 0])
        cylinder(r = rl, h = z);
    }
}



//=============================================================================
// main soild
//=============================================================================

difference() {
    // main mass
    intersection() {
        // for rounded bottom
        rounded_rect_3d([body_w, body_l, alot], body_r);
        
        // for square top
        cube([body_w, body_l, body_h]);
    }

    // main cavity
    translate([wall, wall, wall])
    rounded_rect_3d([cavity_w, cavity_l, alot], cavity_r);
    
    // side slot
    hull() {
        translate([body_w/2, body_l/2, -abit])
        cylinder(d = slot_w, h = alot);
        
        translate([body_w/2, -body_l/2, -abit])
        cylinder(d = slot_w, h = alot);
    }
}
