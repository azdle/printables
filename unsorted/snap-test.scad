//=============================================================================
// snap-test.scad
//
// Single piece snap-on attachment to 20mm t-rail.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

// rail dimensions
railwidth = 30.3;
raildepth = 30.3;
railcornerradius = 1;

slideclearance = 2;

cliplength = 30;

wall = 3;
bodycornerradius = 2;

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 150;

$fn = 20;

difference() {
    union() {
        // main body (rounded rect)
        minkowski() {
            cube([railwidth+wall*2-2*bodycornerradius, raildepth+wall*2-2*bodycornerradius, cliplength-2*bodycornerradius], center=true);
            sphere(r=bodycornerradius);
        }
        
        // handles/hooks/something
        rotate([0,90,0])
        cube([4,4,50], center=true);
        translate([0,0,0])
        rotate([90,0,0])
        cube([4,4,50], center=true);
        
        translate([25,0,0])
        rotate([0,90,0])
        cube([6,8,4], center=true);
        
        translate([-25,0,0])
        rotate([0,90,0])
        cube([6,8,4], center=true);
        
        translate([0,-25,0])
        rotate([90,0,0])
        cube([8,6,4], center=true);
    }
    
    minkowski() {
        cube([railwidth-2*railcornerradius, raildepth-2*railcornerradius, alot], center=true);
        sphere(r=railcornerradius);
    }
    
    // trim open side, leave tabs to lock on
    translate([0,3,-alot/2])
    rotate([0,0,45])
    cube([railwidth, railwidth, alot]);
    
    // ensure tabs won't hit arm slide
    translate([0,alot/2 + raildepth/2 + slideclearance,0])
    cube(alot, center=true);
    
}
