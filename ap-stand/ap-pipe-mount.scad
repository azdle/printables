//=============================================================================
// ap_pipe_mount.scad
//
// A mount to attach an AP to the top of a pipe post.
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

wall = 5;

l_pipe_overlap = 40;
d_pipe_od = 1.35 * 25.4;
d_pipe_id = 1.05 * 25.4;

w_screw_sep = (2 + (9/16)) * 25.4;
d_screw_hole = 2.5;
l_screw_hole = 30;

w_screw_plate = w_screw_sep + 2*wall + d_screw_hole;

l_base = l_pipe_overlap + wall;
d_base = d_pipe_od + 2*wall;

$fn = 150;

abit = 0.05;
alot = 1000;

//=============================================================================
// main soild
//=============================================================================

difference() {
    // main body
    hull() {
        // main cyl
        cylinder(h = l_base, d = d_base);
        
        // backing plate
        translate([-w_screw_plate/2, -d_base/2, 0])
        cube([w_screw_plate, wall, l_base]);
    }
    
    // pipe cutout
    translate([0,0,wall])
    cylinder(h = l_pipe_overlap + wall, d = d_pipe_od);
    
    // pipe cutout
    translate([0,0,-alot/2])
    cylinder(h = alot, d = d_pipe_id);
    
    // screw holes
    translate([w_screw_sep/2,-d_base/2 - abit,l_base/2])
    rotate([270,0,0])
    cylinder(h = l_screw_hole, d = d_screw_hole);
    
    translate([-w_screw_sep/2,-d_base/2 - abit,l_base/2])
    rotate([270,0,0])
    cylinder(h = l_screw_hole, d = d_screw_hole);
    
}