//=============================================================================
// cord-hanger.scad
//
// Holds the power cord off the floor using the slot ment for storing the
// remote on a lasko tower fan.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

width = 12;
thickness = 3;

inner_length = 10;
middle_length = 30;
outter_length = 10;

hanger_opening = 3;
cord_opening = 8;

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 100;

$fa = 1;


union() {
    // hanger hook
    cube([inner_length,thickness+abit,width]);
    
    // hanger_opening
    translate([0,thickness-abit, 0])
    cube([thickness,hanger_opening+abit,width]);
    
    // main vert
    translate([0,thickness+hanger_opening, 0])
    cube([middle_length,thickness+abit,width]);
    
    // cord_opening
    translate([middle_length-thickness,
               thickness*2 + hanger_opening - abit,
               0])
    cube([thickness,cord_opening+abit,width]);
    
    // cord hook
    translate([middle_length-outter_length,
               thickness*2 + hanger_opening + cord_opening - abit,
               0])
    cube([outter_length,thickness+abit,width]);
}
