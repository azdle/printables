//=============================================================================
// universal-spool-adapter.scad
//
// Vertical papertowel holder.
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
baseD = 160;
baseH = 4;
baseRadius = 1;

bumpD = 60;
bumpH = 1;

postTotalD = 35;
postRodD = 15;
postH = 280;
postTurnEvery = 20;

capD = 40;
capH = 20;
capR = 10;

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 150;

$fn = 60;

module donut(d, h) {
    translate([0,0,h/2])
    rotate_extrude()
    translate([d/2-h/2, 0, 0])
    circle(d = h);
}

// openSCAD example 020, CC0
module spring(r1 = 100, r2 = 10, h = 100, hr = 12)
{
  stepsize = 1/64;
  module segment(i1, i2) {
    alpha1 = i1 * 360*r2/hr;
    alpha2 = i2 * 360*r2/hr;
    len1 = sin(acos(i1*2-1))*r2;
    len2 = sin(acos(i2*2-1))*r2;
    if (len1 < 0.01) {
      polygon([
        [ cos(alpha1)*r1, sin(alpha1)*r1 ],
        [ cos(alpha2)*(r1-len2), sin(alpha2)*(r1-len2) ],
        [ cos(alpha2)*(r1+len2), sin(alpha2)*(r1+len2) ]
      ]);
    }
    if (len2 < 0.01) {
      polygon([
        [ cos(alpha1)*(r1+len1), sin(alpha1)*(r1+len1) ],
        [ cos(alpha1)*(r1-len1), sin(alpha1)*(r1-len1) ],
        [ cos(alpha2)*r1, sin(alpha2)*r1 ],
      ]);
    }
    if (len1 >= 0.01 && len2 >= 0.01) {
      polygon([
        [ cos(alpha1)*(r1+len1), sin(alpha1)*(r1+len1) ],
        [ cos(alpha1)*(r1-len1), sin(alpha1)*(r1-len1) ],
        [ cos(alpha2)*(r1-len2), sin(alpha2)*(r1-len2) ],
        [ cos(alpha2)*(r1+len2), sin(alpha2)*(r1+len2) ]
      ]);
    }
  }
  linear_extrude(height = h, twist = 180*h/hr,
                 $fn = (hr/r2)/stepsize*2, convexity = 9) {
    for (i = [ stepsize : stepsize : 1+stepsize/2 ])
      segment(i-stepsize, min(i, 1));
  }
}

// main body
union() {
    // base
    hull(){
        donut(baseD , baseRadius*2);
        
        translate([0,0,baseH - baseRadius*2])
        donut(baseD , baseRadius*2);
    }
    
    // coil
    translate([0,0,baseH + bumpH - abit])
    spring(r1 = (postTotalD-postRodD)/2,
           r2 = postRodD/2,
           h = postH + abit,
           hr = postTurnEvery);
    
    translate([0,0,baseH - abit])
    cylinder(d = bumpD, h = bumpH + abit);
    
    //cap
    translate([0,0,baseH + bumpH + postH - abit])
    hull(){
        donut(capD , capR);
        
        translate([0,0,baseH - baseRadius*2])
        donut(capD, baseRadius);
    }
}