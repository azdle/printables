//=============================================================================
// netgear-switch-rack-mount.scad
//
// For mounting a Netgear GS108PE PoE switch off the side of a rack.
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

plate_height = 2.75;
plate_w = 60;
plate_l = 100;

body_screw_dia = 3; // hole size
body_screw_x = 50;
body_screw_y1 = 10;
body_screw_y2 = 90;
body_screw_standoff_dia = 8;
body_screw_standoff_height = 1;

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

vent_anulus = 20;
vent_x = vent_anulus;
vent_y = vent_anulus;
vent_w = plate_w - 2*vent_anulus;
vent_l = plate_l - 2*vent_anulus;

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
        
        // Top Screw Spacer
        translate([body_screw_x, body_screw_y1, plate_height-abit])
        cylinder(d = body_screw_standoff_dia, h = body_screw_standoff_height);
        // Bottom Screw Spacer
        translate([body_screw_x, body_screw_y2, plate_height-abit])
        cylinder(d = body_screw_standoff_dia, h = body_screw_standoff_height);
        
        // Rack Tab
        translate([0,rack_tab_l/2 + rack_tab_y,0])
        rounded_rect_3d([rack_screw_w * 2, rack_tab_l, plate_height],
                        r = rack_screw_w/2);
    }
    
    // Top Screw Hole
    translate([body_screw_x, body_screw_y1, -alot/2])
    cylinder(d = body_screw_dia, h = alot);
    // Bottom Screw Hole
    translate([body_screw_x, body_screw_y2, -alot/2])
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
