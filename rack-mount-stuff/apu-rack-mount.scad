//=============================================================================
// apu-rack-mount.scad
//
// For mounting a pcEngines APU single board computer, in the first-party
// enclousure. (Tested with the case1d4blku, I assume the mounts are the same.)
//=============================================================================
// Written in 2018 by Patrick Barrett
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

plate_height = 6.5;
plate_w = 160;

body_screw_dia = 3; // hole size
body_screw_x1 = 9;
body_screw_x2 = 9 + 143;
body_screw_y = 9;
body_screw_standoff_dia = 8;
body_screw_standoff_height = 1.5;
body_screw_head_dia = 5.7;
body_screw_head_len = 2;
body_screw_extra_thread_len = 6.2;
body_screw_sink_extra_depth = 
    (plate_height + body_screw_standoff_height)
    - body_screw_extra_thread_len - body_screw_head_len;

rack_tab_top = false;
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
rack_tab_y = rack_tab_top ? plate_l - rack_tab_l : 0;
rack_screw_y = rack_tab_top ? plate_l - rack_screw_y_from_top: rack_screw_y_from_top;
rack_slot_y = rack_tab_top
    ? rack_screw_y - rack_screw_to_slot_y - rack_screw_slot_l/2 + 3.5 //wtf
    : rack_screw_y + rack_screw_y_from_top + rack_screw_slot_l/2;

plate_l = rack_tab_l;

vent_anulus = 15;
vent_x = vent_anulus;
vent_y = vent_anulus;
vent_w = 85;
vent_l = 20;

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

module rounded_tria_3d(dim, r, center = true) {
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
        
        translate([rl, y-rl, 0])
        cylinder(r = rl, h = z);
    }
}

module counter_sunk_screw_hole(d_head, d_hole, l_transition) {
    union() {
        translate([0,0,-abit])
        cylinder(d = d_head, h = alot);
        
        translate([0,0,-l_transition])
        cylinder(d1 = d_hole, d2 = d_head, h = l_transition);
        
        translate([0,0,-alot])
        cylinder(d = d_hole, h = alot);
    }
}


difference() {
    union() {
        // Main Plate
        rounded_tria_3d([plate_w, plate_l, plate_height],
                        r = rack_screw_w/2,
                        center= false);
        
        // First Screw Spacer
        translate([body_screw_x1, body_screw_y, plate_height-abit])
        cylinder(d = body_screw_standoff_dia, h = body_screw_standoff_height);
        // Second Screw Spacer
        translate([body_screw_x2, body_screw_y, plate_height-abit])
        cylinder(d = body_screw_standoff_dia, h = body_screw_standoff_height);
        
        // Rack Tab
        translate([0,rack_tab_l/2 + rack_tab_y,0])
        rounded_rect_3d([rack_screw_w * 2, rack_tab_l, plate_height],
                        r = rack_screw_w/2);
    }
    
    // First Screw Hole
    translate([body_screw_x1, body_screw_y, body_screw_sink_extra_depth])
    rotate([180,0,0])
    counter_sunk_screw_hole(body_screw_head_dia, body_screw_dia, body_screw_head_len);
    // Second Screw Hole
    translate([body_screw_x2, body_screw_y, body_screw_sink_extra_depth])
    rotate([180,0,0])
    counter_sunk_screw_hole(body_screw_head_dia, body_screw_dia, body_screw_head_len);
    
    // Rack Screw Hole
    translate([rack_screw_x, rack_screw_y, -alot/2])
    cylinder(d = rack_screw_dia, h = alot);
    
    // Rack Screw Slot
    translate([rack_screw_x, rack_slot_y, -alot/2])
    raceway_3d(d = rack_screw_dia, l = rack_screw_slot_l, h = alot);
    
    // Vent Hole
    translate([vent_x,vent_y,-alot/2])
    rounded_tria_3d([vent_w, vent_l, alot], r = 2, center = false);
    
}
