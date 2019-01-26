//=============================================================================
// soap-dish.scad
//
// A simple suction cup mounted soap dish for my shower.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

// common
wall = 4;
mount_above_shelf = true;

// main body
b_length = 120;
b_width = 70;
b_radius = 25;
b_lip = 3; // top/bottom lip around edge
h_honeycomb_width = 2;

// back wall
ba_height = 45;

// suction cup
s_key_l = 15;
s_key_s = 10;
s_radius = 25;
s_shaft_length = 3;
s_height = 3;
s_third_point = false;

// customizable variables end here

// ring cavity
c_length = b_length - 2*wall;
c_width = b_width - 2*wall;
c_radius = b_radius - wall;

// honeycomb fill
h_length = b_length - wall;
h_width = b_width - wall;
h_radius = b_radius - wall/2;

// more suction cup
s_height_offset = sqrt(3)/2 * s_radius*2;
s_key_top = mount_above_shelf ? s_key_l : s_key_s;
s_key_bot = mount_above_shelf ? s_key_s : s_key_l;

// more back wall
ba_radius_around_hook = s_key_l/2 + wall;
ba_radius_side = b_length/2 - s_radius - ba_radius_around_hook - wall;

abit = 0.001; //use for making overlap to get single manifold stl
alot = 250;

$fn = 150;

module honeycomb(dim, d, w, center = false) {
    x = dim[0];
    y = dim[1];
    z = dim[2];
    
    D = d * (2/sqrt(3));
    t = d/sqrt(3);
    
    wp = sqrt(3)/2 * w;
    
    translate(center ? [0,0,0] : [x/2,y/2,z/2])
    difference() {
        cube(dim, center = true);
        
        for(i = [0 : D+2*wp+t : x/2+D]) {
            for(j = [0 : d+w : y/2+D]) {
                for(s = [[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0]]) {
                    translate([i*s[0],j*s[1],0*s[2]])
                    cylinder(d = D, h = z+2, $fn = 6, center = true);
                }
            }
        }
        
        for(i = [D/2 + wp + t/2 : D+2*wp+t : x/2+D]) {
            for(j = [d/2+w/2 : d+w : y/2+D]) {
                for(s = [[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0]]) {
                    translate([i*s[0],j*s[1],0*s[2]])
                    cylinder(d = D, h = z+2, $fn = 6, center = true);
                }
            }
        }
        
    }
}

module rounded_rect_3d(dim, r, center = false) {
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

module keyhole(d_large, d_small, center_on_small = true) {
    union() {
        translate(center_on_small ? [0,0,0] : [0,0,-d_large/2])
        rotate([90,0,0])
        cylinder(d = d_small, h = alot, center=true);

        translate(center_on_small ? [0,0,-d_large/2] : [0,0,0])
        rotate([90,0,0])
        cylinder(d = d_large, h = alot, center=true);
        
        hull() {
            rotate([90,0,0])
            cylinder(d = d_large, h = alot/2);
                
            translate([0,0,-d_large/2])
            rotate([90,0,0])
            cylinder(d = d_large, h = alot/2);
        }
    }
}

difference() {
    union() {
        // honeycomb
        translate([wall/2, wall/2, 0])
        intersection() {
            honeycomb([h_length,h_width,wall], 10, h_honeycomb_width);
            translate([0,0,-1])
            rounded_rect_3d([h_length,h_width,wall+b_lip+2], r = h_radius);
        }
        
        // body ring
        difference() {
            // main solid
            rounded_rect_3d([b_length,b_width,wall+b_lip+b_radius], r = b_radius);        
            // main cavity
            translate([wall,wall,-1])
            rounded_rect_3d([c_length,c_width,wall+b_lip+b_radius+2], r = c_radius);
            
            // cut front half
            translate([0, -b_width/2, wall+b_lip])
            cube([b_length, b_width, ba_height]);
            
            // round left back
            translate([0,alot,ba_radius_side+wall+b_lip])
            rotate([90,0,0])
            hull(){
                cylinder(r = ba_radius_side, h = alot);
                translate([wall,0,0])
                cylinder(r = ba_radius_side, h = alot);
                translate([wall,wall,0])
                cylinder(r = ba_radius_side, h = alot);
            }
            
            //round right back
            translate([b_length,alot,ba_radius_side+wall+b_lip])
            rotate([90,0,0])
            hull(){
                cylinder(r = ba_radius_side, h = alot);
                translate([-wall,0,0])
                cylinder(r = ba_radius_side, h = alot);
                translate([-wall,wall,0])
                cylinder(r = ba_radius_side, h = alot);
            }
        }
    
        // back wall
        translate([0, b_width,wall+b_lip+s_radius])
        rotate([90,0,0])
        hull() {
            // left
            translate([b_length/2 - s_radius,0,0])
            cylinder(r = ba_radius_around_hook, h = wall);
            
            // right
            translate([b_length/2 + s_radius,0,0])
            cylinder(r = ba_radius_around_hook, h = wall);
            
            if(s_third_point) {
                translate([b_length/2,s_height_offset,0])
                cylinder(r = ba_radius_around_hook, h = wall);
            }
        }
        
        // bump to level on suction cups
        hull() {
            translate([b_length/2 + 5, b_width, 0])
            cylinder(r = s_height, h = wall+b_lip);
            translate([b_length/2 - 5, b_width, 0])
            cylinder(r = s_height, h = wall+b_lip);
        }
    }
    

    // keyhole
    translate([b_length/2 + s_radius,b_width-s_shaft_length,wall+b_lip+s_radius])
    keyhole(s_key_l, s_key_s, mount_above_shelf);
    
    // keyhole
    translate([b_length/2 - s_radius,b_width-s_shaft_length,wall+b_lip+s_radius])
    keyhole(s_key_l, s_key_s, mount_above_shelf);
    
    if(s_third_point){
        // keyhole
        translate([b_length/2,b_width-s_shaft_length,wall+b_lip+s_radius+s_height_offset])
        keyhole(s_key_l, s_key_s, mount_above_shelf);
    }
}
