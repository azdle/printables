//=============================================================================
// iso-threads.scad
//
// Metric ISO Threads
//=============================================================================
// Written in 2017 by Patrick Barrett
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

$fn = 50;
abit = 0.01;

//=============================================================================
// module
//=============================================================================
    
module thread_unit(d,p) {
    h = sqrt(3)/2 * p;
    t = 360/$fn;
    // point, outter (incl full thread point)
    d_pto = d + 2*(1/8)*h;
    // point, inner (incl full thread point)
    d_pti = d - 2*(7/8)*h;
    // inner
    d_i = (d - 2*(7/8)*h) - 2;
    
    a = t; // angle
    ho = (p/$fn);//*i; // height offset (of bottom)
    points = [
        [d_i/2 * cos(0), d_i/2 * sin(0), p],            // inner top
        [d_pti/2 * cos(0), d_pti/2 * sin(0), p],        // face top
        [d_pto/2 * cos(0), d_pto/2 * sin(0), p/2],      // face middle
        [d_pti/2 * cos(0), d_pti/2 * sin(0), 0],        // face bottom
        [d_i/2 * cos(0), d_i/2 * sin(0), 0],            // inner bottom
        [d_i/2 * cos(a), d_i/2 * sin(a), ho + p],       // inner top
        [d_pti/2 * cos(a), d_pti/2 * sin(a), ho + p],   // face top
        [d_pto/2 * cos(a), d_pto/2 * sin(a), ho + p/2], // face middle
        [d_pti/2 * cos(a), d_pti/2 * sin(a), ho + 0],   // face bottom
        [d_i/2 * cos(a), d_i/2 * sin(a), ho + 0],       // inner bottom
    ];

    itp = 0;  // inner,  top,    previous 
    ftp = 1;  // face,   top,    previous
    fmp = 2;  // face,   middle, previous
    fbp = 3;  // face,   bottom, previous
    ibp = 4;  // inner,  bottom, previous
    itc = 5;  // inner,  bottom, current
    ftc = 6;  // face,   top,    current
    fmc = 7;  // face,   middle, current
    fbc = 8;  // face,   bottom, current
    ibc = 9; //  inner,  bottom, current 
    
    faces = [
        [itp, ftp, fmp, fbp, ibp], // previous face
        [ibp, fbp, fbc, ibc],      // bottom
        [fmp, fmc, fbc, fbp],      // thread face, bottom
        [ftp, ftc, fmc, fmp],      // thread face, top
        [itc, ftc, ftp, itp],      // top
        [ibc, fbc, fmc, ftc, itc], // current face
        [itp, ibp, ibc, itc],      // inner
    ];
    
    polyhedron(
        points = points,
        faces = faces
    );
}

module thread_by_union(diameter, pitch, length) {
    h = sqrt(3)/2 * pitch;
    d_min = diameter - 2*(5/8)*h;
    d_maj = diameter;
    
    intersection(){
        union(){
            for (i = [-$fn:(length/pitch)*$fn]) {
                translate([0,0,(pitch/$fn) * i])
                rotate([0,0,360/$fn * i])
                thread_unit(diameter,pitch);
            }
            
            translate([0,0,-pitch])
            cylinder(d = d_min, h = length + (pitch));
        }
        cylinder(d = d_maj, h = length);
    }
}

//=============================================================================
// main soild
//=============================================================================

thread_by_union(1, 0.5, 1);
