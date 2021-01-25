//=============================================================================
// 2020-stopper.scad
//
// A bracket to block the channel of a 2020 extrusion.
//=============================================================================
// Written in 2021 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================
// dimensions
//=============================================================================

mounting_hole_spacing = 54.3;


$fn = 100;

abit = 0.001;
alot = 100;

//=============================================================================
// main soild
//=============================================================================

use <../unsorted/lib/ISOThread.scad>

module counter_sunk_screw_hole(d_head, d_hole, l_transition) {
    union() {
        translate([0,0,-abit+l_transition])
        cylinder(d = d_head, h = alot);
        
        cylinder(d1 = d_hole, d2 = d_head, h = l_transition);
        
        translate([0,0,-alot])
        cylinder(d = d_hole, h = alot);
    }
}

module profile(l) {
    translate([0,10/2,0])
    hull(){
        translate([0,-5/2,0])
        cube([l,5, 4]);
        translate([0,-10/2,0])
        cube([l,10, 1.5]);
    }
}

rotate([90,0,0])
difference() {
    union() {
        // profile
        translate([-2,0,10])
        rotate([-90,0,90])
        profile(60);
        
        // profile arm
        translate([-2,0,-(6/2) + (10/2)])
        cube([2,60,6]);
        
        // main body
        cube([20,60,10]);
    }
    
    // screw holes
    translate([0,(60-mounting_hole_spacing)/2,0]){
        translate([20-5,0,5])
        rotate([0,90,0])
        counter_sunk_screw_hole(3, 6, 1.75);
        translate([20-5,mounting_hole_spacing,5])
        rotate([0,90,0])
        counter_sunk_screw_hole(3, 6, 1.75);
    }
    
    // component space cutout
    translate([2,5,0])
    cube([18,50,10]);
    
    // lazy cut to make it printable
    translate([-50,30,0])
    cube([alot, alot, 10]);
}