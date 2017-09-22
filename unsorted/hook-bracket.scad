//=============================================================================
// hook-bracket.scad
//
// Bracket for using command strip with some random towel hook I have.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

diameter1 = 46;
diameter2 = 40;
thickness = 6;

left_limit = 20;
right_limit = 10;

dent_depth = 3;

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 100;

$fa = 1;


difference() {
    // main body
    cylinder(h = thickness, d1 = diameter1, d2 = diameter2);
    
    // dent for grub screw
    translate([diameter1/2,0,-alot/2])
    cylinder(h=alot, r = dent_depth);
    
    // right body limit (save printing time, space for strip removal pull)
    translate([-alot/2,0 + right_limit,-alot/2])
    cube([alot,alot,alot]);
    
    // left body limit (save printing time)
    translate([-alot/2,-alot - left_limit,-alot/2])
    cube([alot,alot,alot]);
}
