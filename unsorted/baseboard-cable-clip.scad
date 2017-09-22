//=============================================================================
// baseboard-cable-clip.scad
//
// A simple clip for running cables along the top of a baseboard.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

wall = 0.5;
width = 5;
depth = 15;
cabled =  6;

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 50;

$fn = 200;

module quarter_arc(d, h, w) {
    difference(){
        cylinder(d=d+2*w, h=h);
        translate([0,0,-alot/2])
        cylinder(d=d, h=alot);
        translate([-alot,-alot/2,-alot/2])
        cube([alot,alot,alot]);
        translate([-alot/2,-alot,-alot/2])
        cube([alot,alot,alot]);
    }
}

// main body
union() {
    cube([wall, depth, width]);
    
    translate([cabled/2 + wall,depth,0])
    rotate([0,0,90])
    quarter_arc(cabled, width, wall);
    
    translate([cabled/2 + wall, cabled + wall + depth,0])
    rotate([0,0,-90])
    quarter_arc(cabled, width, wall);
    
    translate([cabled + wall,depth+cabled+wall,0])
    cube([wall, cabled/2, width]);
}