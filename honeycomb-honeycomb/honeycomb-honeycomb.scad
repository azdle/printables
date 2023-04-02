//=============================================================================
// honeycomb-honeycomb.scad
//
// a parametric honeycomb-shaped grid
//=============================================================================
// Written in 2022 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

// dimensions
x = 1; // cell count, vertical
y = 1; // cell count, horizontal

shape = "hexagon"; // [hexagon|rectangle], overall shape

di = 20; // mm, main pod well indiameter (flat to flat distance)
di_notch = 22; // mm, main pod well indiameter (flat to flat distance)

cell_wall = 3.6/2; // mm, cell side wall size
cell_depth = 8;

front_bevel = 0.5; // mm

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 150;

Di = di * (2/sqrt(3)); // mm, circumdiameter of inner side of honeycomb

do = di + (2*cell_wall); // mm, inradius of outter side of honeycomb
Do = do * (2/sqrt(3)); // mm, circumdiameter of outter side of honeycomb

dm = (di+do)/2; // mm, inradius of median of honeycomb
Dm = (Di+Do)/2; // mm, circumdiameter of median of honeycomb

x_min = -floor(x/2);
x_max = floor(x/2);
y_min = -floor(y/2);
y_max = floor(y/2);

// each pod cell
module cell() {
    union() {
        difference() {
            union() {
            Dob = (do - (front_bevel * 2)) * (2/sqrt(3));
            
            cylinder(d1 = Dob, d2 = Do, h = front_bevel, $fn = 6);
            translate([0,0,front_bevel])
            cylinder(d = Do, h = cell_depth - 0.5, $fn = 6);
            }
            
            // cuts, bottom to top
            d1 = (di + (front_bevel * 2)) * (2/sqrt(3));
            d2 = Di;
            d3 = di_notch * (2/sqrt(3));
            
            h1 = front_bevel;
            h2 = 4.6;
            h3 = 0.9;
            h4 = 8;
            translate([0,0,-1])
            cylinder(d = d1, h = 1, $fn = 6);
            translate([0,0,0])
            cylinder(d1 = d1, d2=d2, h = h1, $fn = 6);
            translate([0,0,h1])
            cylinder(d=d2, h = h2, $fn = 6);
            translate([0,0,h1+h2])
            cylinder(d1=d2, d2=d3, h = h3, $fn = 6);
            translate([0,0,h1+h2+h3])
            cylinder(d=d3, h = h4, $fn = 6);
        }
    }
}


module arrange_on_honeycomb() {
    for(i = [x_min:x_max]){
        for(j=[ for (jj=[y_min:y_max]) jj+(0.5 * abs(i%2))]){
            // ^^^ adds 0.5 to odd cols ^^^
            hide = abs(j) > -0.5*(abs(i)) + (y_max - 0.5 * min(0, y_max-x_max))
              || abs(j) > y_max;
            
            if (!hide) {
                x = i * (do * sqrt(3)/2);
                y = j * do;
                translate([x,y,0])
                children();
            }
        }
    }
}

//projection()
difference() {
union() {
    // main cells
    arrange_on_honeycomb(){
        cell();
    }
}
//
//    translate([-39,13.25,0])
//    rotate([0,0,-90])
//    import("/home/patrick/downloads/wall-honeycomb-part.stl");

}
