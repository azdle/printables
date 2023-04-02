//=============================================================================
// hsw-fob-holder.scad
//
// A keyfob holder for the Honeycomb Storage Wall.
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

wall=3;

$fn = 90;

abit = 0.001;
alot = 100;

//=============================================================================
// modules
//=============================================================================

module fob() {
    linear_extrude(10)
    hull() {
        circle(d = 30);
        
        translate([0,-30])
        circle(d = 10);
    }
}

//=============================================================================
// main soild
//=============================================================================

include <../lib/Honeycomb_wall_insert_module.scad>

rotate([90,0,0])
union() {
    // honeycomb wall insert
    rotate([180,0,0])
    hws_insert();

    difference() {
        union() {
            // hook standoff
            difference() {
                cylinder(h = 10, d = 23, $fn = 6);
                
                // chop off top half
                translate([-alot/2,0,-abit])
                cube([alot, alot, alot]);
            }
            
            //main hook body
            translate([0,0,10])
            difference() {
                // fob body
                intersection() {
                    translate([-alot/2,-9.9,-abit])
                    cube([alot, 10, alot]);
                    
                    translate([0,0,wall])
                    minkowski() {
                        fob();
                        sphere(d = wall*2);
                    }
                }
                
                // fob slot
                translate([0,0,3])
                fob();
                
                // fob through
                translate([0,0,12])
                scale([0.9, 0.9, 1]) {
                    fob();
                }
            }
        }
        
        // keyring slot
        translate([0,0,alot/2])
        cube([5,alot,alot], center = true);
    }
}
