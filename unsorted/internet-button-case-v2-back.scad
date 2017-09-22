// internet-button-case.scad
//
// generates an l-bracket from the given parameters


// Copyright (c) 2015, Patrick Barrett
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

wall_thickness = 2.5;
body_diameter = 71.5;
body_depth = 4;

backing_offset = 1.1;

boss_diameter = 5;
boss_height = 3;
boss_internal_diameter = 3;

button_hole_size = 5;
button_hole_offset = 26.1;

header_notch_width = 5.3;
header_notch_length = 32;
header_notch_offset = 10.3;
header_notch_depth_offset = 1.7; // distance from switch post surface ("0")

full_circle = false;
length_up = 20;
length_down = 8;

use_tabs = true;
tab_cut_count = 50;
tab_bump_radius = 0.5;

$fs = 0.5;
$fa = 0.1;

// customizable variables end here

abit = 0.0001;
alot = 1000;

internal_diameter = body_diameter - (wall_thickness*2);

module donut(d, h) {
    rotate_extrude()
    translate([d/2-h/2, 0, 0])
    circle(d = h);
}

difference() {
    union() {
        difference() {
            union() {
                // main body
                cylinder(h = body_depth,
                         d = body_diameter);
                
                translate([0,0,body_depth-tab_bump_radius])
                donut(body_diameter + tab_bump_radius*2, tab_bump_radius*2);
            }
            
            // main cutout
            translate([0,0,wall_thickness])
                cylinder(h = alot, d = internal_diameter);
            
            // cut into tabs
            if(use_tabs)
                translate([0,0,wall_thickness + (body_depth-wall_thickness)/2])
                    for (i=[0:360/tab_cut_count:360])
                        rotate([0,0,i])
                            cube([body_diameter+tab_bump_radius*2,
                                  1,
                                  body_depth-wall_thickness
                                 ], center=true);

        }
        // screw boss
        translate([0,0,wall_thickness-abit])
            cylinder(h = boss_height, d = boss_diameter);
    }
    // screw boss hole
    translate([0,0,-5])
        cylinder(h = alot, d = boss_internal_diameter);
    
    // button shaft holes
    translate([button_hole_offset,0,-5])
        cube([button_hole_size,button_hole_size,alot], center=true);
    translate([-button_hole_offset,0,-5])
        cube([button_hole_size,button_hole_size,alot], center=true);
    
    // header notches
    translate([header_notch_offset,0,alot/2 + header_notch_depth_offset])
        cube([header_notch_width,header_notch_length,alot], center=true);
    translate([-header_notch_offset,0,alot/2 + header_notch_depth_offset])
        cube([header_notch_width,header_notch_length,alot], center=true);
    
    // cut body
    if(!full_circle){
        translate([0,body_diameter/2 + length_up,0])
            cube([body_diameter,body_diameter,body_diameter], center=true);
        translate([0,-(body_diameter/2 + length_down),0])
            cube([body_diameter,body_diameter,body_diameter], center=true);
    }
    
    // cut for backing offset (this is kinda a last minute hack)
    translate([0,0,-alot/2 + backing_offset])
    cube([alot,alot,alot], center=true);
}
