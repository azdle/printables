//=============================================================================
// up-lamp.scad
//
// Simple up  lamp
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

id = 60;
ih = 100;
wall = 3;

// customizable variables end here

od = id + (2 * wall);
oh = ih + wall;

abit = 0.01; //use for making overlap to get single manifold stl
alot = 1000;

$fn = 200;

module disc(od, id, h, center=false) {
    difference() {
        cylinder(d = od, h = h, center = center);
        if (center) {
            cylinder(d = id, h = h*2, center = center);
        } else {
            translate([0,0,-h])
            cylinder(d = id, h = h*2, center = center);
        }
    }
}

// main body
union() {
    // Main Body
    difference() {
        cylinder(d = od, h = oh);
        
        // Main Cutout
        translate([0,0,wall+abit])
        cylinder(d = id, h = ih);
        
        // Backside Cutout
        translate([0,-od/8,oh+od/2])
        rotate([30,0,0])
        cylinder(d = id, h = alot, center=true);
        
        // Ring Detail
        translate([0,0,oh*0.8])
        disc(od = alot, id = od - (wall * 0.3), h = 3
        );
    }
    
    // Light Socket
    difference() {
        
    }
}