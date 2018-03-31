//=============================================================================
// base_pipe_mount.scad
//
// A base to hold up a pipe post.
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

l_mag_offset = 63;
d_mag = 12.5;
h_mag = 3;
d_mag_screw_hole = 2.5;
l_mag_screw_hole = 10;

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
    for (a =[[0,1,0],[-1,0,0],[1,0,0],[0,-1,0]]) {
        difference() {
            hull() {
                // main cyl
                cylinder(h = l_base, d = d_base);
                
                // leg tip
                translate(a * l_mag_offset)
                cylinder(d = 25, h = wall);
            }
            
            // magnet hole
            translate([0,0,h_mag-abit*2])
            translate(a * l_mag_offset)
            cylinder(d = d_mag_screw_hole, h = l_mag_screw_hole);
            
            // magnet screw hole
            translate([0,0,-abit])
            translate(a * l_mag_offset)
            cylinder(d = d_mag, h = h_mag);
        }   
    }
    
    // pipe cutout
    translate([0,0,wall])
    cylinder(h = l_pipe_overlap + wall, d = d_pipe_od);
    
    // cable cutout
    translate([0,0,-alot/2])
    cylinder(h = alot, d = d_pipe_id);
    
}