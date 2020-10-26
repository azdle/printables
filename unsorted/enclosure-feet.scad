//=============================================================================
// enclosure-feet.scad
//
// Small legs for a lack table meant for a printer enclosure.
//=============================================================================
// Written in 2020 by Patrick Barrett
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

wall = 2;

h_socket_neck = 2.5;
d_socket_neck = 40;
d_socket_ring = 56;

l_pipe_overlap = 40;
d_pipe_od = 1.35 * 25.4;
d_pipe_id = 1.05 * 25.4;

l_mag_offset = 63;
d_mag = 12.5;
h_mag = 3;
d_mag_screw_hole = 2.5;
l_mag_screw_hole = 10;

l_pipe_transition = (d_pipe_od - d_pipe_id)/2;
l_pipe_base = l_pipe_overlap + wall;
d_pipe_base = d_pipe_od + 2*wall;

$fn = 150;

abit = 0.05;
alot = 1000;

//=============================================================================
// modules
//=============================================================================

module rounded_rect_3d(dim, r, center = true) {
    x = dim[0];
    y = dim[1];
    z = dim[2];
    
    // limit diameter to half of x or y
    rl = r > x/2 ? x/2 : (r > y/2 ? y/2 : r);
    
    translate(center ? [-x/2, -y/2, -z/2] : [0,0,0])
    hull() {
        translate([rl, rl, 0])
        cylinder(r = rl, h = z);
        
        translate([x-rl, rl, 0])
        cylinder(r = rl, h = z);
        
        translate([x-rl, y-rl, 0])
        cylinder(r = rl, h = z);
        
        translate([rl, y-rl, 0])
        cylinder(r = rl, h = z);
    }
}
module rounded_rect_race_3d(dim, r, center = true) {
    x = dim[0];
    y = dim[1];
    z = dim[2];
    
    // limit diameter to half of x or y
    rl = r > x/2 ? x/2 : (r > y/2 ? y/2 : r);
    
    translate(center ? [-x/2, -y/2, -z/2] : [0,0,0])
    union() {
        hull(){
            translate([rl, rl, 0])
            cylinder(r = rl, h = z);
            
            translate([x-rl, rl, 0])
            cylinder(r = rl, h = z);
        }
        hull(){
            translate([rl, rl, 0])
            cylinder(r = rl, h = z);
            
            translate([rl, y-rl, 0])
            cylinder(r = rl, h = z);
        }
        hull(){
            translate([x-rl, rl, 0])
            cylinder(r = rl, h = z);
            
            translate([x-rl, y-rl, 0])
            cylinder(r = rl, h = z);
        }
        hull(){
            translate([x-rl, y-rl, 0])
            cylinder(r = rl, h = z);
            
            translate([rl, y-rl, 0])
            cylinder(r = rl, h = z);
        }
    }
}

//=============================================================================
// main soild
//=============================================================================

difference() {
    union(){
        // main body
        translate([0,0,25])
        rounded_rect_3d([50,50,50], r=1.5);
        
        hull(){
            cylinder(d = d_pipe_base, h = l_pipe_base);
            translate([25+d_pipe_base/2,0,0])
            cylinder(d = d_pipe_base, h = l_pipe_base);
        }
    }
    
    
    // screw head cutout
//    translate([0,0,2])
//    rounded_rect_race_3d([30,30,4], r=5);
    translate([0,0,50-2])
    rounded_rect_3d([30,30,4], r=5);
    
    // screw hole
    cylinder(h=alot, d=6);
    
    // pipe cutout
    translate([25+d_pipe_base/2,0,-wall-l_pipe_transition])
    cylinder(h = l_pipe_overlap + wall, d = d_pipe_od);
    
    translate([25+d_pipe_base/2,0,l_pipe_overlap-l_pipe_transition])
    cylinder(h = l_pipe_transition + wall, d1 = d_pipe_od, d2 = d_pipe_id);
    
    // cable cutout
    translate([25+d_pipe_base/2,0,-alot/2])
    cylinder(h = alot, d = d_pipe_id);   
}