//=============================================================================
// sg-1000-rack-mount.scad
//
// For moutning a Netgate SG-1000 off the side of a rack.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================
// Conventions
//
// * x,y,z     are offsets
// * l,w,h,d,r are dimensions
//=============================================================================
// dimensions
//=============================================================================

plate_height = 2.75;
plate_w = 51;
plate_l = 78.5;

plate_spacer_depth = 1.25;
plate_spacer_y = 15;
plate_spacer_length = plate_l - (plate_spacer_y * 2);
plate_spacer_width = 5;
plate_spacer_x_a = 6.5;
plate_spacer_x_b = plate_w - plate_spacer_width - plate_spacer_x_a;

body_screw_dia = 3; // hole size
body_screw_x = 25.25;
body_screw_y = 71;
body_screw_standoff_dia = 8;
body_screw_standoff_height = plate_spacer_depth;

rack_screw_w = 18;
rack_screw_dia = 7; // hole size
rack_screw_slot_l = 28;
rack_screw_x = -((rack_screw_dia/2) + 5);
rack_screw_y_from_top = rack_screw_w/2;
rack_screw_to_slot_y = 12.4; // head size
rack_tab_l = rack_screw_y_from_top +
             rack_screw_to_slot_y +
             rack_screw_slot_l +
             rack_screw_w/2 -
             3.5 * 2; // wtf
rack_tab_y = plate_l - rack_tab_l;
rack_screw_y = plate_l - rack_screw_y_from_top;
rack_slot_y = rack_screw_y - rack_screw_to_slot_y - rack_screw_slot_l/2 + 3.5; //wtf

vent_anulus = 1;
vent_x = plate_spacer_x_a + plate_spacer_width + vent_anulus;
vent_y = vent_x;
vent_w = plate_spacer_x_b - (plate_spacer_x_a + plate_spacer_width) - 2*vent_anulus;
vent_l = plate_l - vent_x * 2;

$fn = 100;

abit = 0.001;
alot = 100;

//=============================================================================
// main soild
//=============================================================================

module raceway_3d(d, l, h) {
    hull() {
        translate([0,-l/2+d/2, 0])
        cylinder(d = d, h = h);
        translate([0,l/2-d/2, 0])
        cylinder(d = d, h = h);
    }
}

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

difference() {
    union() {
        // Main Plate
        rounded_rect_3d([plate_w, plate_l, plate_height],
                        r = rack_screw_w/2,
                        center= false);
        
        // Spacer Bar A
        translate([plate_spacer_x_a, plate_spacer_y, plate_height-abit])
        cube([plate_spacer_width, plate_spacer_length, plate_spacer_depth]);
        
        // Spacer Bar B
        translate([plate_spacer_x_b, plate_spacer_y, plate_height-abit])
        cube([plate_spacer_width, plate_spacer_length, plate_spacer_depth]);
        
        // Body Screw Spacer
        translate([body_screw_x, body_screw_y, plate_height-abit])
        cylinder(d = body_screw_standoff_dia, h = body_screw_standoff_height);
        
        // Rack Tab
        translate([0,rack_tab_l/2 + rack_tab_y,0])
        rounded_rect_3d([rack_screw_w * 2, rack_tab_l, plate_height],
                        r = rack_screw_w/2);
    }
    
    // Body Screw Hole
    translate([body_screw_x, body_screw_y, -alot/2])
    cylinder(d = body_screw_dia, h = alot);
    
    // Rack Screw Hole
    translate([rack_screw_x, rack_screw_y, -alot/2])
    cylinder(d = rack_screw_dia, h = alot);
    
    // Rack Screw Slot
    translate([rack_screw_x, rack_slot_y, -alot/2])
    raceway_3d(d = rack_screw_dia, l = rack_screw_slot_l, h = alot);
    
    // Vent Hole
    translate([vent_x,vent_y,-alot/2])
    rounded_rect_3d([vent_w, vent_l, alot], r = 2, center = false);
    
}
