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
// main soild
//=============================================================================

//points_pre = [
//    [0,0,0]
//];
//
//faces_pre = [
//    [bc, be, bs], // bottom face
//    [bc, bs, ms, ts, tc], // wall to center, start
//];
    

//
//points_post = [
//    [0,0,H*revs]
//];
//
//faces_post = 
//    let (os = len(points_pre) + len(points_main)) // offset
//    let (bo = 0)    // bottom, origin
//    let (tp = os-6) // top,    previous
//    let (mp = os-5) // middle, previous
//    let (bp = os-4) // bottom, previous
//    let (tc = os-3) // top,    current
//    let (mc = os-2) // middle, current
//    let (be = os-1) // bottom, current
//    let (to = os) // top, origin
//    [
//        [tc, tc, mc, bc, bo], // wall to center, end
//        [to, tp, te], // top face
//    ];
//
//
//points = concat(
//    points_pre,
//    points_main,
//    points_post
//);
//    
//echo(points);

function flatten(pointArray, done=0, res=[]) =
    (done == len(pointArray)) ?
        res :
        flatten(pointArray=pointArray, done=done+1,
            res=concat(res,pointArray[done]));

function thread_points(d, p, revs = 1) = flatten([ 
    let (h = sqrt(3)/2 * p)
    let (t = 360/$fn)
    // point, outter (incl full thread point)
    let (d_pto = d + 2*(1/8)*h)
    // point, inner (incl full thread point)
    let (d_pti = d - 2*(7/8)*h)
    for (i = [0:(revs*$fn)])
    let (a = t*i) // angle
    let (ho = (p/$fn)*i) // height offset (of bottom)
    [
        [d_pti/2 * cos(a), d_pti/2 * sin(a), ho + p - abit],   // top
        [d_pto/2 * cos(a), d_pto/2 * sin(a), ho + p/2], // middle
        [d_pti/2 * cos(a), d_pti/2 * sin(a), ho + 0],   // bottom
    ]
]);

function thread_faces(points_count, offset=0) = flatten([
    for (i = [offset+3:3:points_count]) // skip first, start at offset
    let (os = i+offset) // local offset
    let (tp = os-3) // top,    previous
    let (mp = os-2) // middle, previous
    let (bp = os-1) // bottom, previous
    let (tc = os+0) // top,    current
    let (mc = os+1) // middle, current
    let (bc = os+2) // bottom, current
    i != offset+3 && i != points_count-3 ?
    [
        [bp, bc, mc, mp], // thread face, bottom
        [mp, mc, tc, tp], // thread face, top
        [tp, tc, bc, bp], // thread face, top
    ]
    :
    i == offset+3 ?
    [
        [bp, mp, tp], // opening face
        [bp, bc, mc, mp], // thread face, bottom
        [mp, mc, tc, tp], // thread face, top
        [tp, tc, bc, bp], // thread face, top
    ]
    :
    [
        [bp, bc, mc, mp], // thread face, bottom
        [mp, mc, tc, tp], // thread face, top
        [tp, tc, bc, bp], // thread face, top
        [tc, mc, bc], // closing face
    ]
]);
    
module thread_unit(d,p) {
    h = sqrt(3)/2 * p;
    t = 360/$fn;
    // point, outter (incl full thread point)
    d_pto = d + 2*(1/8)*h;
    // point, inner (incl full thread point)
    d_pti = d - 2*(7/8)*h;
    
    a = t; // angle
    ho = (p/$fn);//*i; // height offset (of bottom)
    points = [
        [0,0,p],
        [d_pti/2 * cos(0), d_pti/2 * sin(0), p],   // top
        [d_pto/2 * cos(0), d_pto/2 * sin(0), p/2], // middle
        [d_pti/2 * cos(0), d_pti/2 * sin(0), 0],   // bottom
        [d_pti/2 * cos(a), d_pti/2 * sin(a), ho + p],   // top
        [d_pto/2 * cos(a), d_pto/2 * sin(a), ho + p/2], // middle
        [d_pti/2 * cos(a), d_pti/2 * sin(a), ho + 0],   // bottom
        [0,0,0],
    ];

    os = 4; // local offset
    to = os-4; // top, origin
    tp = os-3; // top,    previous
    mp = os-2; // middle, previous
    bp = os-1; // bottom, previous
    tc = os+0; // top,    current
    mc = os+1; // middle, current
    bc = os+2; // bottom, current
    bo = os+3; // bottom, origin
    faces = [
        [bo, bp, mp, tp, to], // previous face
        [bo, bc, bp],         // bottom
        [bp, bc, mc, mp],     // thread face, bottom
        [mp, mc, tc, tp],     // thread face, top
        [to, tp, tc],         // top
        [to, tc, mc, bc, bo], // current face
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
    points = thread_points(diameter, pitch, 1);
    faces = thread_faces(len(points));
    
    echo(points);
    echo(len(points));
    echo(faces);

//    intersection(){
//        union() {
//            for (i = [-1:length/pitch]) {
//                translate([0,0,pitch*i]){
//                    polyhedron(
//                        points = points,
//                        faces = faces
//                    );
//                    //cylinder(d = d_min, h = length + pitch);
//                }
//            }
//        }
//        
//      //cylinder(d = d_maj, h = length);
//    }
    //intersection(){
        union(){
            for (i = [-$fn:(length/pitch)*$fn + $fn]) {
                translate([0,0,(pitch/$fn) * i])
                rotate([0,0,360/$fn * i])
                thread_unit(diameter,pitch);
            }
            //cylinder(d = d_min, h = length);
        }
        //cylinder(d = d_maj, h = length);
    //}
}

//thread_by_union(4, 0.5, 0.5);
thread_unit(4, 0.5);
