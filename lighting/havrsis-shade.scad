//=============================================================================
// havsris-shade.scad
//
// Lamp shade for IKEA's HAVSRIS cordset.
//=============================================================================
// Written in 2023 by Patrick Barrett
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

include <BOSL2/std.scad>

wall = 1;

body_base_id = 65;
body_end_id = 145;
body_h = 120;

socket_d = 40;
socket_body_d = 47.9;
socket_body_l = 50; // ?

$fn = 150;

abit = 0.01;
alot = 1000;

body_base_od = body_base_id + 2*wall;
body_end_od = body_end_id + 2*wall;

slot_w = (body_base_id - socket_body_d)/4;
slot_d = body_base_id - (body_base_id - socket_body_d)/2;

//=============================================================================
// main soild
//=============================================================================

difference() {
    // main body
    cylinder(d1 = body_base_od, d2 = body_end_od, h = body_h);
    
    // main cavity
    translate([0,0,wall])
    cylinder(d1 = body_base_id, d2 = body_end_id, h = body_h);
    
    // socket hole
    translate([0,0,-abit])
    cylinder(d = socket_d, h = alot);
    
    // vent holes
    zrot_copies(n=4)
    linear_extrude(alot, center=true)
    stroke(arc(r=slot_d/2, angle=45, start=45/2), width = slot_w);
    
    // socket body shadow
    %translate([0,0,-socket_body_l])
    cylinder(d = socket_body_d, h = socket_body_l);
}