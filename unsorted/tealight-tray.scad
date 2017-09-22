//=============================================================================
// tealight-tray.scad
//
// A simple tray for storing tealights, keeping them from rolling around.
//=============================================================================
// Written in 2017 by Patrick Barrett
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this work to the public domain
// worldwide. This work is distributed without any warranty.
//
// See <http://creativecommons.org/publicdomain/zero/1.0/> for full dedication.
//=============================================================================

candledia = 38;
candleheight = 13.6;
candlerows = 2;
candlecols = 12;
depthpercent = 30;

minwall = 3;

// customizable variables end here

abit = 0.001; //use for making overlap to get single manifold stl
alot = 150;

$fn = 200;

bw = candlerows * candledia + 2*minwall;
bl = candlecols * candleheight + 2*minwall;
bh = (depthpercent/100) * candledia + minwall;

candlerowlen = candleheight * candlecols;

if(depthpercent>50 || depthpercent<0){
    echo("<font color='red'>ERROR: depthpercent has to be an integer in the range 0-50 (%)</font>");
    assert(false);
}

module donut(d, h) {
    translate([0,0,h/2])
    rotate_extrude()
    translate([d/2-h/2, 0, 0])
    circle(d = h);
}
// main body
difference() {
    cube([bw, bl, bh]);
    
    for(i = [0:candlerows-1]) {
        translate([candledia*i, 0, 0])
        translate([candledia/2 + minwall, minwall, candledia/2 + minwall])
        rotate([-90,0,0])
        cylinder(h = candlerowlen, d = candledia);
    }
}