//=============================================================================
// drawer-slide-rack-rail-mount.scad
//
// A mounting bracket for using cheapo full extension ball bearing drawer
// slides as rackmount server case sliding rack rails.
//=============================================================================
// Written in 2022 by Patrick Barrett
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

// minimum wall thickness
wall = 2.5;

// used for optomizing for supportless printing
layer_height = 0.3;

drawer_slide_h = 43.69;
drawer_slide_w = 12.3;

server_case_w = 430;

rail_nut_d = 7; // minimal diameter, flat to flat
rail_nut_l = 3;
rail_nut_sides = 6;
rail_screw_l = 16.5; // threaded portion only
rail_screw_clearance_d = 4;
rail_screw_positions = [/**/35, 99,/** / 93, 157/**/]; // measured from each face
rail_screw_slot_l = 5;
rail_surface_thickness = 0.8;
rail_offset = 5; // must be larger than rack_surface_thickness + any gap you want

inches = 25.4;

rack_unit_h = 1.75 * inches;
rack_unit_gap = (1/32) * inches;
rack_unit_holes = [-0.625 * inches, 0, 0.625 * inches]; // from center

rack_nut_d = 11; // face to face
rack_nut_l = 4.45;
rack_nut_sides = 4;
rack_screw_l = 13.75; // threaded portion only
rack_screw_head_d = 12;
// center of side rack hole to face of actual rack
rack_screw_offset = 25;
rack_screw_clearance_d = 6;
rack_surface_w = 14;
rack_surface_thickness = 2;
rack_face_to_face_l = 490;
rack_f2f_w = 469;
rack_opening_w = 439;


rack_nubin_wl = 9.35;
rack_nubin_h = 1.5;

$fn = 150;

abit = 0.05;
alot = 1000;

rack_units_usable_h = function(u) (rack_unit_h * u) - rack_unit_gap;

// convert measured minimal diameter to the maximal diameter for `cylinder`
maximal_rail_nut_d = 2* ((rail_nut_d/2) / cos(180/rail_nut_sides));

// convert measured minimal diameter to the maximal diameter for `cylinder`
maximal_rack_nut_d = 2* ((rack_nut_d/2) / cos(180/rack_nut_sides));

rack_screw_hole_l = rack_screw_l - rack_surface_thickness - rack_nut_l;
rail_screw_hole_l = rail_screw_l - rail_surface_thickness - rail_nut_l;
min_body_w = rail_screw_hole_l + rail_nut_l;

body_h = rack_units_usable_h(1);
oversized_body_h = (max(rack_unit_holes) + rack_nut_d/2 + wall) * 2;
oversized_rack_surface_w = rack_nut_d + wall*2;

body_w = (rack_face_to_face_l - server_case_w)/2 - drawer_slide_w;

use <../lib/threads.scad>

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

union() {
    difference() {
        union() {
            hull() {
                // flat part touching rack
                translate([-oversized_body_h/2,
                           -oversized_rack_surface_w/2 + rack_screw_offset
                               + rack_surface_thickness,
                           0])
                cube([oversized_body_h, oversized_rack_surface_w, body_w]);  
                
                // cyl centered on furthest screw
                translate([0,max(rail_screw_positions) + rail_screw_slot_l/2 + rail_offset,0])
                cylinder(d = maximal_rail_nut_d + 2*wall, h = min_body_w);
            }
            
            // alignment nubins            
            for(x = rack_unit_holes) {
                translate([x, rack_screw_offset  + rack_surface_thickness, body_w])
                rounded_rect_3d([rack_nubin_wl, rack_nubin_wl, rack_nubin_h], 1);
            }
        }

        
        // rack holes
        for(x = rack_unit_holes) {
            translate([x, rack_screw_offset + rack_surface_thickness, -alot/2])
            cylinder(d = rack_screw_clearance_d, h = alot);
            

            translate([x,
                       rack_screw_offset + rack_surface_thickness,
                       -alot + body_w - rack_screw_hole_l])
            rotate([0,0,360/2/rack_nut_sides]) // flats to the side
            cylinder(d = maximal_rack_nut_d, h = alot, $fn = rack_nut_sides);
            
            translate([x,
                       rack_screw_offset + rack_surface_thickness,
                       body_w - rack_screw_hole_l])
            cube([rack_screw_clearance_d, rack_nut_d, layer_height*2], center=true);
        }
        
        
        // rail holes
        for(y = rail_screw_positions) {
            y = y + rail_offset;
            hull() {
                translate([0, y + rail_screw_slot_l/2, -alot/2])
                cylinder(d = rail_screw_clearance_d, h = alot);
                
                translate([0, y - rail_screw_slot_l/2, -alot/2])
                cylinder(d = rail_screw_clearance_d, h = alot);
            }

            hull() {
                translate([0, y + rail_screw_slot_l/2, rail_screw_hole_l])
                rotate([0,0,360/2/rail_nut_sides]) // flats to the side
                cylinder(d = maximal_rail_nut_d, h = alot, $fn = rail_nut_sides);
                
                translate([0, y - rail_screw_slot_l/2, rail_screw_hole_l])
                rotate([0,0,360/2/rail_nut_sides]) // flats to the side
                cylinder(d = maximal_rail_nut_d, h = alot, $fn = rail_nut_sides);
            }
        }
    }
}