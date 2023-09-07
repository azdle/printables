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

wall = 1;

body_id = 65;
body_h = 120;

socket_d = 40;

$fn = 150;

abit = 0.01;
alot = 1000;

body_od = body_id + 2*wall;

//=============================================================================
// main soild
//=============================================================================

difference() {
    cylinder(d = body_od, h = body_h);
    
    translate([0,0,wall])
    cylinder(d = body_id, h = alot);
    
    translate([0,0,-abit])
    cylinder(d = socket_d, h = alot);
}
    