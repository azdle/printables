//=============================================================================
// vita-multi-cart-case-insert.scad
//
// Store more vita games in a single case.
//=============================================================================
// Written in 2021 by Patrick Barrett
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

// warning: only partly parametric, some values are scattered below, just FYI.

wall = 1;

body_w = 100;
body_l = 130;
body_r = 1;
body_h = 7.5; // total interior height (-0.5 for space for tape)

cutout_w = 35;
cutout_l = 62;

// all 0.15 mm oversized
cart_w = 22.1;
cart_l = 31.05;
cart_h = 2.1;
cart_top_d = 60; // diameter of the arc across the top

side_cut_l = 100;
side_cut_r = 1.5;
side_cut_w = 2.6;

socket_clip_l = 4;
socket_clip_w = 0.5;
socket_clip_gap = 1;
socket_clip_offset = 10; // from top of cart to middle of clip
socket_clip_overhang = 0.4; // amount to project inward into cavity
socket_raise = 3; // from back wall (this - wall = finger slot gap)

$fn = 150;

abit = 0.05;
alot = 1000;

socket_w = cart_w +2*wall;
socket_l = cart_l +2*wall;
//=============================================================================
// modules
//=============================================================================

module rounded_rect_3d(dim, r=0, center = true) {
    x = dim[0];
    y = dim[1];
    z = dim[2];
    
    // limit diameter to half of x or y
    rl = r > x/2 ? x/2 : (r > y/2 ? y/2 : r);    
    
    if(r > 0) {
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
    } else {
        translate([0,0,center? dim.z/2 : 0])
        cube(dim, center=center);
    }
}

module cart_outline(h, r=0, o=0) {
    outline_w = cart_w + o;
    outline_l = cart_l + o;
    outline_top_d = cart_top_d + o;
    
    intersection(){
        rounded_rect_3d([outline_w, outline_l, h], 0);
        
        translate([0, -outline_top_d/2 + outline_l/2])
        cylinder(d=outline_top_d, h=h);
    }
}

module cart_socket() {
    union() {
        difference(){
            // body
            hull() {
                cart_outline(h = body_h - wall,
                             r = body_r,
                             o = 5);
                
                cart_outline(h = abit,
                             r = body_r,
                             o = 9.5);
            }
                
            // cavity
            translate([0, 0, socket_raise])
            union() {
                // actual cart space
                cart_outline(h = cart_h);
                
                // inside bevel
                hull() {
                    translate([0,0,cart_h])
                    cart_outline(h = cart_h);
                    
                    translate([0,0,body_h - wall - socket_raise])
                    cart_outline(h = alot,
                                 r = wall,
                                 o = 2*wall);
                }
            }
            
            //fingerslot
            hull() {
                cylinder(d = cart_w * 0.75, h = alot);
                
                translate([0,alot,0])
                cylinder(d = cart_w * 0.75, h = alot);
            }
            
            // clips socket
            translate([0,cart_l/2 - socket_clip_offset,socket_raise])
            rounded_rect_3d([alot, socket_clip_l + 2*socket_clip_gap, alot]);
        }
        
        // left clip
        translate([-cart_w/2 - socket_clip_w/2,
                   cart_l/2 - socket_clip_offset,
                   0])
        {
            translate([0,0,socket_raise])
            rounded_rect_3d([socket_clip_w, socket_clip_l, cart_h]);
            
            translate([0,0,socket_raise + cart_h])
            hull() {
                // clip back
                rounded_rect_3d([socket_clip_w,
                                 socket_clip_l,
                                 socket_clip_overhang * 2]);         
                
                // clip tip
                translate([socket_clip_overhang/2,0,socket_clip_overhang])
                rounded_rect_3d([socket_clip_w + socket_clip_overhang,
                                 socket_clip_l,
                                 abit],
                                socket_clip_overhang);
            }
        }
        
        // right clip
        translate([cart_w/2 + socket_clip_w/2,
                   cart_l/2 - socket_clip_offset,
                   0])
        {
            translate([0,0,socket_raise])
            rounded_rect_3d([socket_clip_w, socket_clip_l, cart_h]);
            
            translate([0,0,socket_raise + cart_h])
            hull() {
                // clip back
                rounded_rect_3d([socket_clip_w,
                                 socket_clip_l,
                                 socket_clip_overhang * 2]);         
                
                // clip tip
                translate([-socket_clip_overhang/2,0,socket_clip_overhang])
                rounded_rect_3d([socket_clip_w + socket_clip_overhang,
                                 socket_clip_l,
                                 abit],
                                socket_clip_overhang);    
            }
        }
    }
}


//=============================================================================
// main soild
//=============================================================================

union(){
    difference() {
        union() {
            // back wall
            rounded_rect_3d([body_w, body_l, wall], body_r, center=false);
            
            // sockets
            for(i = [[1, [1,2,3]], [2, [1]], [3, [1,3]]]) {
                for(j = i.y) {
                    translate([i.x*body_w/3 - body_w/(3*2),
                               j*body_l/3 - body_l/(3*2),
                               wall])
                    cart_socket();
                }
            }
        }
        
        // cutout for existing cart holder
        translate([body_w/2,43 + cutout_l/2,0])
        rounded_rect_3d([cutout_w, cutout_l, alot], body_r);
        
        // side cut for clips & grip slot
        translate([body_w, body_l/2, 0])
        rounded_rect_3d([side_cut_w * 2, side_cut_l, 10], side_cut_r);
    }
}