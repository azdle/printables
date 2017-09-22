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

wall_thickness = 1.5;
cavity_diameter = 71.75;
cavity_depth = 11;

inner_sholder_radius = 3;
outer_sholder_radius = 2;

tab_height = 4;
tab_bump_radius = 0.5;

usb_slot_width = 12.7;
usb_slot_depth = 2.7;

$fs = 0.5;
$fa = 0.1;

// customizable variables end here

abit = 0.0001;
alot = 1000;

body_diameter = cavity_diameter + wall_thickness*2;
body_depth = cavity_depth;

module donut(d, h) {
    rotate_extrude()
    translate([d/2-h/2, 0, 0])
    circle(d = h);
}

difference() {
    hull() {
        // main body
        translate([0,0,outer_sholder_radius])
            cylinder(h = body_depth - outer_sholder_radius,
                     d = body_diameter);
        
        translate([0,0,outer_sholder_radius])
            donut(body_diameter, outer_sholder_radius*2);
    }
    
    hull(){
        // main cutout
        translate([0,0,inner_sholder_radius])
            cylinder(h = alot, d = cavity_diameter);
            
        translate([0,0,inner_sholder_radius-0.0]) // fudge needed
            donut(cavity_diameter, inner_sholder_radius*2);
    }
    
    // tab notch
    translate([0,0,body_depth-tab_height])
        donut(cavity_diameter+tab_bump_radius, tab_bump_radius*2);
    
    // usb slot
    translate([0,alot/2,-abit])
    cube([usb_slot_width,alot,usb_slot_depth], center=true);
    
}
