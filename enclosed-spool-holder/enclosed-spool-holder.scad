//=============================================================================
// enclosed-spool-holder.scad
//
// A spool holder that uses a clear plastic container to cover the spool. This
// part is just the base, it requires a "16 cup Premium Modular Canister" #1R04
// from Rubbermaid as the top.
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

body_h = 30;

container_w = 110;
container_l = 236;
container_r = 30;

seal_w = 5; // seal cavity width (anulus)
seal_h = 2; // seal cavity depth

bearing_d_o = 22;
bearing_d_o_seal = 20;
bearing_d_i = 8;
bearing_w = 7;
bearing_gap = 2;

feed_hole_l = 50;
feed_hole_w = 10;
feed_hole_offset = 5;

body_w = container_w + seal_w + wall;
body_l = container_l + seal_w + wall;
body_r = container_r + (seal_w + wall)/2;

cavity_w = container_w - seal_w - wall - (bearing_w + bearing_gap)*2;
cavity_l = container_l - seal_w - wall;
cavity_r = container_r - (seal_w + wall)/2 - (bearing_w + bearing_gap);

seal_w_o = container_w + seal_w;
seal_w_i = container_w - seal_w;
seal_l_o = container_l + seal_w;
seal_l_i = container_l - seal_w;
seal_r_o = container_r + seal_w/2;
seal_r_i = container_r - seal_w/2;

$fn = 100;

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
    
    translate(center ? [-x/2, -y/2, 0] : [0,0,0])
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

// uses globals
module bearing_pair_slot() {
    translate([0,0,bearing_d_o/2])
    rotate([90,0,0])
    union() {
        // bearing 1
        translate([0,0,cavity_w/2 + bearing_w/2 + bearing_gap])
        hull() {
            cylinder(d = bearing_d_o, h = bearing_w, center=true);
            
            translate([0,body_h,0])
            cylinder(d = bearing_d_o, h = bearing_w, center=true);
        }
    
        // bearing 2
        translate([0,0,-(cavity_w/2 + bearing_w/2 + bearing_gap)])
        hull() {
            cylinder(d = bearing_d_o, h = bearing_w, center=true);
            
            translate([0,body_h,0])
            cylinder(d = bearing_d_o, h = bearing_w, center=true);
        }
        
        // connection rod & back-side space
        inner_rod_w = cavity_w + bearing_w + bearing_gap*2;
        hull() {
            cylinder(d = bearing_d_o_seal, h = inner_rod_w, center=true);
                    
            translate([0,body_h,0])
            cylinder(d = bearing_d_o_seal, h = inner_rod_w, center=true);
        }
        
        // connection rod & back-side space
        rod_w = cavity_w + bearing_w*2 + bearing_gap*4;
        cylinder(d = bearing_d_o_seal, h = rod_w, center=true);
    }
}


//=============================================================================
// main soild
//=============================================================================

difference() {
    // main mass
    rounded_rect_3d([body_l, body_w, body_h], body_r);
    
    // main cavity
    translate([0,0,wall])
    rounded_rect_3d([cavity_l, cavity_w, body_h], cavity_r);
    
    // seal slot
    translate([0,0,body_h-seal_h])
    difference() {
        rounded_rect_3d([seal_l_o, seal_w_o, seal_h+abit], seal_r_o);
        rounded_rect_3d([seal_l_i, seal_w_i, seal_h+abit], seal_r_i);
    }
    
    // bearing slots for rollers
    for (x =[0:bearing_d_o + wall:cavity_l/2-cavity_r-bearing_d_o/2]) {
        translate([x,0,wall])
        bearing_pair_slot();
        
        translate([-x,0,wall])
        bearing_pair_slot();
    }
   
    // feed hole
    translate([cavity_l/2 - feed_hole_w/2 - feed_hole_offset,0,0])
    hull() {
        translate([0,feed_hole_l/2 - feed_hole_w/2,0])
        cylinder(d = feed_hole_w, h = alot, center = true);
        translate([0,-(feed_hole_l/2 - feed_hole_w/2),0])
        cylinder(d = feed_hole_w, h = alot, center = true);
    }
}
