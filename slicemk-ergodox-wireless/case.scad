//=============================================================================
// ergodox-wireless-case.scad
//
// A case for a Wireless Ergodox from SliceMK.
//=============================================================================
// Written in 2021 by Patrick Barrett
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

part = "bottom"; // ["top", "bottom", "assembly"]

wall = 6;
chamfer = 2;

sandwhich_h = 8.5; // top of plate to bottom of things poking through pcb
key_surround_h = 4.25; // top of plate to top of main body
base_plate_h = 3; // retainer plate that closes in the bottom.

corners_path = [[90,90], [90,194.5], [90,108.5], [90,80.5], [-25,94.5]];

main_key_opening_w = 144;
main_key_opening_x = 3;
main_key_opening_h = 102;
main_key_opening_y = 3;

thumb_key_opening_w = 91;
thumb_key_opening_x = 3;
thumb_key_opening_h = 59;
thumb_key_opening_y = 3;
thumb_key_corner_idx = 3;

usb_hole_w = 9;
usb_hole_h = 3; //?????
usb_hole_panel_depth = 0.5;
usb_cable_w = 12.5;
usb_cable_h = 6.5;
usb_cable_board_edge_depth = 5;
usb_port_center_z = 3.5; // from far side of PCB

controller_cavity_h = 11;
controller_cavity_l = 70;
controller_cavity_w = 43;
solar_panel_w = 15.25;
solar_panel_l = 45.5;
solar_panel_h = 2;

standoff_od = 7;

// for m3 screw
screw_head_d = 6.72;
screw_head_l = 1.86;
screw_body_d = 3;

function cum_angle_at_point(path, i) =
    i >= 0 ? cum_angle_at_point(path, i-1) + path[i][0] : 0;
function gen_point(path, i) = let(
    node = path[i],
    dist = node[1],
    angle = cum_angle_at_point(path, i),
    offset_x = dist * cos(angle),
    offset_y = dist * sin(angle)
)
    i > 0 ? gen_point(path, i-1) + [offset_x,offset_y] : [offset_x, offset_y];
    
corner_points = [ [0,0],
                   for( i = [0 : len(corners_path)-1])
                       gen_point(corners_path, i)
                ];
corner_angles = [for( i = [0 : len(corners_path)-1])
                    cum_angle_at_point(corners_path, i)
                ]; 

body_h = sandwhich_h + key_surround_h + base_plate_h;
main_cavity_h = sandwhich_h + base_plate_h;

$fn = 100;

abit = 0.001;
alot = 50;

use <../lib/threads.scad>

//=============================================================================
// main soild
//=============================================================================

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

module counter_sunk_screw_head(d_head, d_body, l_transition) {
    union() {
        translate([0,0,-abit])
        cylinder(d = d_head, h = alot);
        
        translate([0,0,-l_transition])
        cylinder(d1 = d_body, d2 = d_head, h = l_transition);
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

module honeycomb_negative(dim, d, w, center = false, taper=false) {
    x = dim[0];
    y = dim[1];
    z = dim[2];
    
    D = d * (2/sqrt(3));
    t = d/sqrt(3);
    
    wp = sqrt(3)/2 * w;
    
    translate(center ? [0,0,-2*abit] : [x/2,y/2,z/2]){
        for(i = [0 : D+2*wp+t : x/2+D]) {
            for(j = [0 : d+w : y/2+D]) {
                for(s = [[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0]]) {
                    translate([i*s[0],j*s[1],0*s[2]]) {
                        cylinder(d = D, h = z+(abit*4), $fn = 6, center = true);
                        
                        if (taper) {
                            translate([0,0,z/2 + D/4])
                            cylinder(d1 = D, d2 = abit, h = D/2,
                                     $fn = 6, center = true);
                        }
                    }
                            
                }
            }
        }
        
        for(i = [D/2 + wp + t/2 : D+2*wp+t : x/2+D]) {
            for(j = [d/2+w/2 : d+w : y/2+D]) {
                for(s = [[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0]]) {
                    translate([i*s[0],j*s[1],0*s[2]]) {
                        cylinder(d = D, h = z+(abit*4), $fn = 6, center = true);
                        
                        if (taper) {
                            translate([0,0,z/2 + D/4])
                            cylinder(d1 = D, d2 = abit, h = D/2,
                                     $fn = 6, center = true);
                        }
                    }
                }
            }
        }
        
    }
}

// Builds polygons with only convex corners, by path.
// rounding extends outward from points
// `points` is [[x1,y1], ...]
module rounded_polygon_points(points, h, r, top_chamfer = 0) {
    minkowski(){
        linear_extrude(abit)
        polygon(points);
        
        union() {
            cylinder(r = r, h = h-top_chamfer);
            
            if (top_chamfer > 0) {
                translate([0,0,h-top_chamfer])
                cylinder(r1=r, r2=r-top_chamfer, h = top_chamfer);
            }
        }
    }
}

// Builds polygons with only convex corners, by path.
// rounding extends outward from points
// `path` is [[angle,distance], ...]
module rounded_polygon_path(path, h, r, top_chamfer = 0) {
    points = [ [0,0], for( i = [0 : len(path)-1]) gen_point(path,i)];
    rounded_polygon_points(points, h, r, top_chamfer=top_chamfer);
}

module standoff() {
    ScrewHole(3, 125)
    cylinder(d = standoff_od, h = sandwhich_h + key_surround_h);
}

module top() {
    union() {
        difference() {
            //main solid
            rounded_polygon_path(corners_path, body_h, wall, top_chamfer=2);
            
            // main cavity
            translate([0,0,-abit])
            rounded_polygon_path(corners_path, main_cavity_h, 2);
            
            // main key cutout
            translate([
                -192.65+main_key_opening_x,
                88.71-main_key_opening_h-main_key_opening_y,
                -abit])
            cube([main_key_opening_w,main_key_opening_h,alot]);
            
            // thumb key cutout
            translate([
                corner_points[5].x - thumb_key_opening_x * cos(corner_angles[4])
                                   - thumb_key_opening_y * sin(corner_angles[4]),
                corner_points[5].y + thumb_key_opening_y * cos(-corner_angles[4])
                                   + thumb_key_opening_x * sin(-corner_angles[4]),
                -abit])
            rotate([0,0,corner_angles[4]-180])
            translate([0,-thumb_key_opening_h,0])
            cube([thumb_key_opening_w+10,thumb_key_opening_h,alot]);
            
            // controller cavity
            translate([-controller_cavity_w,
                       corner_points[1].y - controller_cavity_l])
            union(){
                //main pcb
                cube([controller_cavity_w,
                      controller_cavity_l,
                      controller_cavity_h + base_plate_h]);
                
                // headers, in case they're not cut perfectly flush
                cube([3,
                      controller_cavity_l,
                      1 + controller_cavity_h + base_plate_h]);
                  
                // solarpanels
                translate([controller_cavity_w - solar_panel_w*2 - 6.75,
                           controller_cavity_l - solar_panel_l - 6.75,
                           0])
                cube([solar_panel_w*2,solar_panel_l,alot]);
                
                // usb port
                translate([controller_cavity_w + usb_hole_panel_depth,
                           controller_cavity_l/2,
                           controller_cavity_h + base_plate_h
                           - usb_port_center_z])
                rotate([0, 90, 0])
                union(){
                    translate([0,0,-alot/2])
                    rounded_rect_3d([usb_hole_h, usb_hole_w, alot], 2,
                                     center=true);
                    
                    rounded_rect_3d([usb_cable_h, usb_cable_w, alot], 2,
                                    center=true);
                    hull() {
                        translate([0,0,usb_cable_board_edge_depth])
                        rounded_rect_3d([usb_cable_h, usb_cable_w, alot], 2,
                                        center=true);
                        
                        translate([0,0,wall])
                        rounded_rect_3d([usb_cable_h*2, usb_cable_w*2, alot], 2,
                                        center=true);
                    }
                }
            }
                            
            // screw head cuts, heads overlap with frame slightly 
            for (point = corner_points) {
                translate([point.x, point.y, 0])
                rotate([0,180])
                counter_sunk_screw_head(screw_head_d,
                                        screw_body_d,
                                        screw_head_l);
            }
            
        }
        
        for (point = corner_points) {
            translate([point.x, point.y, base_plate_h + abit])
            standoff();
        }
    }
}

module bottom() {
    difference() {
        union() {
            // solid plate
            rounded_polygon_path(corners_path, 3, 1.5);
            
            // supports
            difference() {
                translate([0,0,3])
                union(){
                    //keyplate supports
                    difference(){
                        linear_extrude(1.5)
                        difference() {
                            polygon(corner_points);
                            offset(delta = -3)
                            polygon(corner_points);
                        }
                    }

                    // controller support - top
                    translate([-controller_cavity_w+abit,
                               corner_points[1].y - 2.5+abit,
                               0])
                    cube([controller_cavity_w,2.5, 9.5]);

                    // controller support - bottom
                    translate([-controller_cavity_w+abit,
                               corner_points[1].y - controller_cavity_l,
                               0])
                    cube([controller_cavity_w,2.5, 9.5]);
                }
                
                // standoff cutouts
                for (point = corner_points) {
                    translate([point.x, point.y, -alot/2])
                    cylinder(d=standoff_od+1, h=alot);
                }
                    
                // connector pins/sockets & battery connector cutout
                translate([-controller_cavity_w ,
                           corner_points[1].y - controller_cavity_l-abit,
                           -abit])
                cube([15,controller_cavity_l+abit*4, alot]);
            }
        }
        

        // honeycomb pattern, except around edge
        intersection() {
            translate([0,0,-alot/2])
            linear_extrude(alot)
            offset(delta = -3)
            polygon(corner_points);
            
            translate([-200, -100, 0])
            honeycomb_negative([200, 200, 3], 8, 1, taper=true);
            
        }
                    
        // screw holes
        for (point = corner_points) {
            translate([point.x, point.y, 0])
            rotate([0,180])
            counter_sunk_screw_hole(screw_head_d,
                                    screw_body_d,
                                    screw_head_l);
        }
    }
}

if (part == "top") {
    top();
} else if (part == "bottom") {
    bottom();
} else {
    // assembly
    color("red")
    top();
    
    color("blue")
    bottom();
}