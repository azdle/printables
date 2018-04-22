//=============================================================================
// fan_adaptor.scad
//
// An adaptor to mount a 140 mm fan to a 120 mm opening without obscuring part
// of the fan face.
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

wall = 3;

af_do = 120;
af_di = 117;
af_sd = 4;
af_sw = 105;

bf_do = 140;
bf_di = 137;
bf_sd = 5;
bf_sw = 105;

flair_h = 3.5;
transition_h = 13;

full_h = 2*flair_h + transition_h;

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


//=============================================================================
// main soild
//=============================================================================

difference() {
    union() {
        // a fan
        translate([0,0,flair_h + transition_h])
        cylinder(h = flair_h, d = af_do);
        
        // connection
        translate([0,0,flair_h])
        cylinder(h = transition_h, d2 = af_do, d1 = bf_do);
        
        // square fill
        translate([0,0,0])
        rounded_rect_3d([af_do, af_do, full_h], 5, center = true);
        
        //b fan
        cylinder(h = flair_h, d = bf_do);
        
        // b fan tabs
        hull() {
            translate([af_sw * 0.707,0,0])
            cylinder(d = bf_sd + 2*wall, h = flair_h);
            
            translate([-af_sw * 0.707,0,0])
            cylinder(d = bf_sd + 2*wall, h = flair_h);
        }
        hull() {
            translate([0,af_sw * 0.707,0])
            cylinder(d = bf_sd + 2*wall, h = flair_h);
            
            translate([0,-af_sw * 0.707,0])
            cylinder(d = bf_sd + 2*wall, h = flair_h);
        }
    }
    
    union() {
        // a fan
        translate([0,0,flair_h + transition_h])
        cylinder(h = flair_h, d = af_di);
        
        // connection
        translate([0,0,flair_h])
        cylinder(h = transition_h, d2 = af_di, d1 = bf_di);
        
        //b fan
        cylinder(h = flair_h, d = bf_di);
    }
    
    // a fan screw holes
    for (a =[[1,1,0],[1,-1,0],[-1,1,0],[-1,-1,0]]) {
        // magnet screw hole
        translate([0,0,-alot/2])
        translate(a * (af_sw/2))
        cylinder(d = af_sd, h = alot);
    }
    
    // b fan screw holes
    for (a =[[0,1,0],[0,-1,0],[-1,0,0],[1,0,0]]) {
        // magnet screw hole
        translate([0,0,-alot/2])
        translate(a * (bf_sw * 0.707))
        cylinder(d = bf_sd, h = alot);
    }
}
    