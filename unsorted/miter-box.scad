//=============================================================================
// miter-box.scad
//
// A simple tray for storing tealights, keeping them from rolling around.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

width = 60; // mm, internal
length = 80; // mm, internal
height = 25; // mm, internal

slot = 1.5; // mm, internal
slot_angles = [0 ,45]; // deg, automatically mirrored

wall = 3; // mm, the side thickness
base = 3; // mm, the bottom thickness
base_cut = 1; // mm, the extra cutting space at the bottom

// customizable variables end here

tw = width + (wall * 2);
tl = length + (wall * 2);
th = height + base + base_cut;
tb = base + base_cut;

abit = 0.0001; //use for making overlap to get single manifold stl
alot = 1500;

// main body
difference() {
    translate([0,0,th/2])
    cube([tw, tl, th], center=true);
    
    translate([0, 0, alot/2 + tb])
    cube([width, alot, alot], center=true);
    
    for(i = slot_angles) {
        rotate([0,0,i])
        translate([0, 0, alot/2 + base])
        cube([alot, slot, alot], center=true);
        
        rotate([0,0,-i])
        translate([0, 0, alot/2 + base])
        cube([alot, slot, alot], center=true);
    }
}