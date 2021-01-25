//=============================================================================
// pixel-badge-one-piece-diffuser.scad
//
// A single-print diffuser for the pixel badge, optionally multi-material.
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

// generate pixels as seperate solid
multi_material = false;
// which part to generate (choose main if not doing multi-material)
part = "main"; // [main, pixels]

// style of frame, "thick" covers the ESP antenna. "slim" uses less plastic
frame = "thick"; // [slim, thick]

// width of frame on "thin" setting
frame_wall_thin = 2;
// width of frame on "thick" setting
frame_wall_thick = 5.8;
// thickness of translucent layer (adjust to one or two layers)
face_wall = 0.2;

// leave space for usb cable
usb_cutout = true;

// height of usb cable (also assumed radius)
usb_h = 8;
// width of usb cable
usb_w = 13;
// height of center of plug from board
usb_offset_h = 2;
// distance from center of plug to bottom edge of board
usb_offset_w = 6;

// add mounting holes
mounting_holes = true;

// diameter of mounting holes
mounting_hole_d = 3.8;
// length (depth) of mounting holes
mounting_hole_l = 3;

// thickness of wall between pixels
pixel_wall = 1;
// on-center distance between pixels
pixel_spacing_x = 6;
// on-center distance between pixels
pixel_spacing_y = 6;
// space between face of LED and face of diffuser
pixel_depth = 2.5;

// number of pixels wide
pixels_x = 32;
// number of pixels tall
pixels_y = 8;

// PCB outline, longer dimension (measured at 192.2, added space for v-score variation)
board_x = 192.5;
// PCB outline, shorter dimension
board_y = 48.5;
// PCB thickness
board_z = 1.66;

// outline of LED package (not currently used)
led_x = 3.62;
// outline of LED package (not currently used)
led_y = 2.8;
// thickness of LED from board
led_h = 1.91;

// generate clips
clips = true;
// list of clip positions along top (x, relative to board viewed from rear)
clips_top = [35, 80, 177];
// list of clip positions along bottom (x, relative to board viewed from rear)
clips_bottom = [33, 120, 180];
// list of clip positions along right (y, relative to board viewed from rear)
clips_left = [25];
// list of clip positions along left (y, relative to board viewed from rear)
clips_right = [25];

// width of connected part of clip
clip_foot_width = 5;
// depth of the non-sloped part of the foot 
clip_foot_sholder = 2;
// width of flexible bridge
clip_bridge_width = 10;
// thickness of flexible bridge
clip_bridge_thickness = 1;
// a bridge for the bridge, this is a straight section below the clip
// to allow for proper bridging
clip_support_bridge_height = 0.5;

// width of tab (along board)
clip_tab_width = 3;
// overall height of tab
clip_tab_height = 1.5;
// overall protrusion distance of tab at tip
clip_tab_depth = 1;
// horizontal flat at base of tab
clip_tab_flat_depth = 0.2;
// upward angle on underside of tab to account for droop
clip_tab_underside_angle = 15;

clip_tab_tip_height = (clip_tab_depth - clip_tab_flat_depth)
                      * tan(clip_tab_underside_angle);

pixel_x = pixel_spacing_x - pixel_wall;
pixel_y = pixel_spacing_y - pixel_wall;

frame_wall = frame == "thick" ? frame_wall_thick : frame_wall_thin;

// pixel depth, inner face to board
pixel_board_depth = pixel_depth + led_h;

// overall height of pixel wall from bottom
pixel_h = pixel_board_depth+face_wall;

body_x = (frame_wall * 2) + board_x;
body_y = (frame_wall * 2) + board_y;
body_z = face_wall + pixel_board_depth + board_z;

// offset to align pixel grid (assumes LEDs are centered on board)
pixel_offset_x = abs((body_x - (pixels_x * pixel_spacing_x)) / 2);
pixel_offset_y = abs((body_y - (pixels_y * pixel_spacing_y)) / 2);

$fn=60;

abit = 0.05;
alot = 1000;

// checks

if (mounting_holes) {
    assert(mounting_hole_d < frame_wall,
           "holes in frame can't be larger than frame");
}

//=============================================================================
// modules
//=============================================================================

// a positive of the shape of an individual pixel
//
// edit this to change the shape of individual pixels
// should be in positive octant only (ie. not centered)
module pixel(h) {
    cube([pixel_x,pixel_y,h]);
}

// a positive grid of pixels
module pixel_grid(h) {
    translate([pixel_wall/2, pixel_wall/2, 0])
    for(x = [0:31]) {
        for(y = [0:7]) {
            translate([pixel_spacing_x * x, pixel_spacing_y * y, 0])
            pixel(h);
        }
    }
}

module usb_cut() {
    translate([0,usb_h/2-usb_w/2,0])
    rotate([0,90,0])
    hull() {
      translate([0,usb_w-usb_h,0])
      cylinder(d = usb_h, h = frame_wall*2); 
      cylinder(d = usb_h, h = frame_wall*2);  
    }
}

// board clip
//
// clip faces toward -y
// board edge at y=0
// board surface ad z=0
// centered at x=0
module clip() {
    // left leg
    translate([-clip_foot_width - clip_bridge_width/2,0,0])
    hull() {
        translate([0,0,clip_tab_height-abit])
        cube([clip_foot_width, clip_foot_sholder, abit]);
        cube([clip_foot_width, frame_wall, abit]);
    }

    // right leg
    translate([clip_bridge_width/2,0,0])
    hull() {
        translate([0,0,clip_tab_height-abit])
        cube([clip_foot_width, clip_foot_sholder, abit]);
        cube([clip_foot_width, frame_wall, abit]);
    }

    //bridge (incl negative support bridge)
    translate([-clip_bridge_width/2,0,-clip_support_bridge_height])
    cube([clip_bridge_width,
          clip_bridge_thickness,
          clip_tab_height+clip_support_bridge_height
    ]);

    //tab
    translate([clip_tab_width/2,0,0])
    rotate([90,0,-90])
    linear_extrude(clip_tab_width)
    polygon(points = [
        [0,0],
        [clip_tab_flat_depth,0],
        [clip_tab_depth,clip_tab_tip_height],
        [0,clip_tab_height] 
    ]);
}

module clip_subtract() {
    translate([-10/2,0,-board_z])
    cube([10,2,board_z+(abit*2)]);
}

//=============================================================================
// main soilds
//=============================================================================

module main() {
    union() {
        difference() {
            // body outline
            cube([body_x, body_y, body_z]);
            
            // board cutout
            translate([frame_wall, frame_wall, pixel_h])
            cube([board_x, board_y, body_z]);
            // ^ z = body_z to ensure cut-through
            
            pixel_cut_height = multi_material ? -abit : face_wall;
            
            // pixel cutouts
            translate([pixel_offset_x, pixel_offset_y, pixel_cut_height])
            pixel_grid(body_z);
            
            // mounting holes
            if(mounting_holes) {
                hole_offset_x = frame_wall/2;
                hole_space_x = body_x - frame_wall;
                hole_offset_y = frame_wall/2;
                hole_space_y = body_y - frame_wall;
                hole_offset_z = body_z-mounting_hole_l+abit;
                
                echo("hole spacing", hole_space_x, hole_space_y); 
                
                for(x = [0:0.5:1]) {
                    for(y = [0:1]) {
                        translate([
                            hole_space_x * x + hole_offset_x,
                            hole_space_y * y + hole_offset_y,
                            hole_offset_z])
                        cylinder(d = mounting_hole_d, h = mounting_hole_l);
                    }
                }
            }
            
            if (usb_cutout) {
                translate([body_x - frame_wall,
                           frame_wall + usb_offset_w,
                           body_z + usb_offset_h])
                usb_cut();
            }
            // clip voids
            for (clip = clips_top) {
                translate([clip + frame_wall,
                           frame_wall + board_y - abit,
                           body_z])
                clip_subtract();
            }
            for (clip = clips_bottom) {
                translate([clip + frame_wall, frame_wall, body_z - abit])
                rotate([0,0,180])
                clip_subtract();
            }
            for (clip = clips_left) {
                translate([frame_wall, clip + frame_wall, body_z - abit])
                rotate([0,0,90])
                clip_subtract();
            }
            for (clip = clips_right) {
                translate([frame_wall + board_x,
                           clip + frame_wall,
                           body_z - abit])
                rotate([0,0,270])
                clip_subtract();
            }
        }
        
        // clips
        for (clip = clips_top) {
            translate([clip + frame_wall, frame_wall + board_y, body_z - abit])
            clip();
        }
        for (clip = clips_bottom) {
            translate([clip + frame_wall, frame_wall, body_z - abit])
            rotate([0,0,180])
            clip();
        }
        for (clip = clips_left) {
            translate([frame_wall, clip + frame_wall, body_z - abit])
            rotate([0,0,90])
            clip();
        }
        for (clip = clips_right) {
            translate([frame_wall + board_x, clip + frame_wall, body_z - abit])
            rotate([0,0,270])
            clip();
        }
    }
}

module pixel_faces() {
    if (multi_material) {
        translate([pixel_offset_x, pixel_offset_y, 0])
        pixel_grid(face_wall);
    }
}

if(part == "pixels") {
    pixel_faces();
} else {
    main();
}