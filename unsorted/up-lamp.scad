//=============================================================================
// up-lamp.scad
//
// Minimalistic up lamp for a PAR38 flood lamp bulb.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

// dimensions
diameter = 80; // internal
idepth = 30; // internal
iradius = 3;
oradius_bottom = 4;
oradius_top = 1;

lipradius = 2;

lockradius = 0.5;
lockdepth = 2;


wall = 3;

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 150;

$fn = 200;

odiameter = idiameter+(2*wall);
lipdiameter = odiameter+(2*lipradius);

height = idepth+wall;

module donut(d, h) {
    translate([0,0,h/2])
    rotate_extrude()
    translate([d/2-h/2, 0, 0])
    circle(d = h);
}
// main body
difference() {
    union() {
        hull(){
            donut(odiameter , oradius_bottom*2);
            
            translate([0,0,height])
            cylinder(d=odiameter, h=abit);
        }
        
        // top lip
        translate([0,0,idepth+wall-lipradius])
        difference() {
            h = sqrt(pow(lipradius,2) - pow(lipradius/2, 2));
            
            hull(){
                donut(lipdiameter , lipradius*2);
                
                translate([0,0,-3*h])
                cylinder(d=idiameter, h=abit);
            }
            
            translate([0,0,-2*h])
            donut(lipdiameter+2*lipradius, 2*lipradius);
        }

    }        
    
    // inner cavity
    translate([0,0,wall])
    hull(){
        donut(idiameter , iradius*2);
        
        translate([0,0,idepth+abit+2])
        cylinder(d=idiameter, h=abit);
    }
    
    // lock ridge
    
    translate([0,0,idepth+wall-lockdepth])
    donut(idiameter + 2*lockradius , lockradius*2);
}