//=============================================================================
// bird-feeder.scad
//
// Parametric window bird feeder.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

// main body
length = 100;
width = 40;
depth = 20;

wall = 1;
radius = 10;

drain_size = 0.5;

tilt = 20; // deg

// perch
p_offset = 20;
p_diameter = 5;

// suction cup mount
m_key_l = 15;
m_key_s = 10;



// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 150;

$fn = 60;

module capped_cylinder(d, h) {
    hull() {
        translate([0,0,h/2])
        sphere(d=d);
        
        translate([0,0,-h/2])
        sphere(d=d);
    }
}

union(){
    // main body
    difference() {
        union() {
            // cup shell
            minkowski() {
                cube([ (width-radius)*2,
                       length-(radius*2),
                       (depth-radius)*2
                     ],
                     center = true);
                sphere(r = radius);
            }
            
            // perch
            p_length = length - (radius *2);
            translate([width+p_offset,0,-depth+p_diameter/2])
            rotate([90,0,0])
            capped_cylinder(d = p_diameter, h = p_length, center = true);
            
            translate([0,p_length/2,-depth+p_diameter/2])
            rotate([0,90,0])
            cylinder(d = p_diameter, h = (width+p_offset)*2, center = true);
            
            translate([0,-p_length/2,-depth+p_diameter/2])
            rotate([0,90,0])
            cylinder(d = p_diameter, h = (width+p_offset)*2, center = true);
        }
       
        // cut cup
        minkowski() {
            cube([ (width-radius)*2,
                   length-(radius*2),
                   (depth-radius)*2
                 ],
                 center = true);
            sphere(r = radius-wall);
        }

        // cut top
        translate([0,0,alot/2])
        cube([alot, alot, alot], center = true);
        
        // cut back
        rotate([0,-tilt,0])
        translate([-alot/2,0,0])
        cube([alot, alot, alot], center = true);
        
        // cut drain slot
        translate([width-radius,0,0])
        cube([drain_size, length-(radius*2), alot], center = true);
        
    }
    
    // back wall
    rotate([0,-tilt,0])
    difference() {
        // wall
        translate([0,-(length-radius*2)/2,-(depth-radius)+(-1)]) //fudge
        minkowski(){
            cube([wall, length-(radius*2), depth-radius]);
            
            translate([0,0,0])
            rotate([0,90,0])
            cylinder(r = radius, h = wall);
        }
        
        // keyhole
        translate([0,0,-m_key_l/2])
        rotate([0,90,0])
        cylinder(d = m_key_l, h = alot, center=true);
        
        rotate([0,90,0])
        cylinder(d = m_key_s, h = alot, center=true);
    }
}
