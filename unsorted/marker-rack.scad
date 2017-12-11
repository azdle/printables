//=============================================================================
// marker-rack.scad
//
// Hang markers an an eraser.
//=============================================================================
// Written in 2017 by Patrick Barrett
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

w_body = 75;

wall = 4;

d_marker = 21;

h_eraser = 33;

$fn = 100;

some = 10;
alot = 250;
abit = 0.01;

//=============================================================================
// main soild
//=============================================================================

module round_cube(sides, r = 0, center = false) {
    translate(center ? [0,0,0] : [r,r,r])
    minkowski() {
        cube([sides[0]-r, sides[1]-r, sides[2]-r], center = center);
        sphere(r = r);
    }
}

module marker_dish() {
    translate([0,-(d_marker/2 + wall),0])
    difference() {
        cylinder(d = d_marker + 2*wall, h = w_body);
        
        translate([0,0,-some/2])
        cylinder(d = d_marker, h = w_body + some);
        
        translate([-d_marker*0.25,-d_marker/2 -some + 1,-some/2])
        cube([d_marker + some, d_marker/2 + some, w_body + some]);
        
        translate([0,0,-some/2])
        cube([d_marker, d_marker, w_body + some]);
    }
}

difference() {
    union() {
        translate([-abit, -wall, 0])
        cube([5.5*d_marker, wall, w_body]);
        
        marker_dish();

        translate([1.5*d_marker,0,0])
        marker_dish();

        translate([3*d_marker,0,0])
        marker_dish();
        
        translate([4.5*d_marker, -h_eraser-wall, 0])
        cube([wall, h_eraser, w_body]);
        
        translate([4.5*d_marker, -h_eraser-wall, 0])
        cube([20, wall, w_body]);
    }
    
    // cutout
    translate([-d_marker,-wall,w_body/2])
    rotate([-45+180,0,0])
    cube([d_marker*4, alot, alot]);
}