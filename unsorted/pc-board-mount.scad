//=============================================================================
// pc-board-mount.scad
//
// Magnetic circuit board mount.
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

wall = 2.5;

body_h = 5;
body_r = 5;

board_w = 43;
board_l = 50;

screw_w = 37;
screw_l = 45;
screw_d = 2.75;
screw_wall = 2.5;

magnet_d = 13;
magnet_h = 3;

body_w = board_w + 2*wall;
body_l = board_l + 2*wall;

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


//=============================================================================
// main soild
//=============================================================================

union(){
    difference() {
        union() {
            rounded_rect_3d([body_w, body_l, body_h], body_r);
            
            // magnet wings
            hull() {
                translate([0,(body_l + magnet_d)/2 + wall,0])
                cylinder(r = magnet_d/2 + wall, h = body_h, center = true);
                
                translate([0,-(body_l + magnet_d)/2 - wall,0])
                cylinder(r = magnet_d/2 + wall, h = body_h, center = true);
            }
        }
        
        difference() {
            cube([board_w, board_l, 2*body_h], center = true);
            
            for(i = [[1,1],[1,-1],[-1,-1],[-1,1]]) {
                m = i[0];
                n = i[1];
                translate([m * screw_w/2, n * screw_l/2, 0])
                cylinder(d = screw_d + 2*screw_wall, h = body_h, center = true);
            }
        }
        
        for(i = [[1,1],[1,-1],[-1,-1],[-1,1]]) {
            m = i[0];
            n = i[1];
            translate([m * screw_w/2, n * screw_l/2, 0])
            cylinder(d = screw_d, h = body_h*2, center = true);
        }
        
        
        translate([0,(body_l + magnet_d)/2 + wall,body_h - magnet_h])
        cylinder(d = magnet_d, h = body_h, center = true);
        
        translate([0,-(body_l + magnet_d)/2 - wall,body_h - magnet_h])
        cylinder(d = magnet_d, h = body_h, center = true);
    }
}