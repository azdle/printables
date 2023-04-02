include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/shapes3d.scad>
// Generates insert-empty, insert-full and a flat-sided variation of both, with or without the front hexagon emboss.
// Made to make it easy to include in other OpenSCAD models.

verticalSpacing = 23.6;
horizontalSpacing = 40.88;



module hws_insert(centerHole=false, lateralTabs=true, frontDecoration=false,flatSide=true) {
    //Parameters to change in case you deviated from the standard Honeycomb Wall
    hexHeight = 19.8;
    insideHexHeight = 13.40;
    insertDepth = 7.67;
    //Parameters you should not change unless you know what you're doing.
    frontDepth = 2; 
    frontExtension = 1.5;
    gapVert = 1;
    gapHor = 0.8;
    gapLen = 8;
    gapVertDepth = 3.5;
    gapHorDepth = 1.6;
    bumpHeight = 0.5;
    bumpWidth = 2;
    bumpLen = gapVertDepth - gapHor - bumpHeight*2;
    bumpAng = 20;
    //insert assembly using other modules
    difference() {
        union() {
            insert(hexHeight,insertDepth,frontDepth,frontExtension);
            if(lateralTabs) tabBumps(bumpHeight=bumpHeight,hexHeight=hexHeight,insertDepth=insertDepth,frontDepth=frontDepth,bumpLen=bumpLen,bumpAng=bumpAng);
        }
        if (lateralTabs) tabsCutout(hexHeight=hexHeight,gapHorDepth=gapHorDepth,insertDepth=insertDepth,frontDepth=frontDepth,gapLen=gapLen,gapVert=gapVert,gapVertDepth=gapVertDepth,gapHor=gapHor, flatSide=flatSide);
        if (centerHole) insertHole(insideHexHeight=insideHexHeight,insertDepth=insertDepth,frontDepth=frontDepth);
        if (frontDecoration) hexCutout(innerHexHeight=insideHexHeight+1.55);
        if (flatSide) sideFlattener(hexHeight=hexHeight, fullInsertDepth=insertDepth+frontDepth);
    }
}


module hws_insert_n_vert(centerHole=false, lateralTabs=true, frontDecoration=false,flatSide=false,n=2,blanks=1) {
    ycopies(verticalSpacing*(1+blanks),n=n) hws_insert(centerHole=centerHole, lateralTabs=lateralTabs, frontDecoration=frontDecoration,flatSide=flatSide);
}

module hws_insert_n_hor(centerHole=false, lateralTabs=true, frontDecoration=false,flatSide=false,n=2,blanks=0) {
    xcopies(horizontalSpacing*(1+blanks),n=n) hws_insert(centerHole=centerHole, lateralTabs=lateralTabs, frontDecoration=frontDecoration,flatSide=flatSide);
}

module hws_insert_rail(length=verticalSpacing+20,width=19.7,n=1,depth=2){
    hws_insert_n_hor(centerHole=false, lateralTabs=true, frontDecoration=false,flatSide=false,n=n,blanks=0);
    prismoid(size1=[length,width+3], size2=[length,width], h=depth, anchor=TOP);
}
//Auxiliary modules. Coded separately for readability.
module insert(hexHeight,insertDepth,frontDepth,frontExtension) {
    union() {
        //insert
        rounded_prism(hexagon(d=2/sqrt(3)*hexHeight), h=insertDepth+frontDepth, anchor=BOTTOM, joint_top=0.25, joint_sides=.2, splinesteps=1);
        //insert front edge
        rounded_prism(hexagon(d=2/sqrt(3)*(hexHeight+frontExtension)), h=frontDepth, anchor=BOTTOM, joint_bot=.3, joint_sides=.1, splinesteps=1);
    }
}

module insertHole(insideHexHeight,insertDepth,frontDepth) {
    down(0.05)rounded_prism(hexagon(d=2/sqrt(3)*(insideHexHeight)), h=insertDepth+frontDepth+0.1, anchor=BOTTOM, joint_top=-0.25, joint_bot=-0.25, splinesteps=1);
}

module tabsCutout(hexHeight,gapHorDepth,insertDepth,frontDepth,gapLen=8,gapVert,gapVertDepth,gapHor,flatSide=false) {
    difference() {
        rot_copies(n=6, v=UP, delta=[0,hexHeight/2-gapHorDepth,0]) union() {
            up(insertDepth+frontDepth+.1) cuboid([gapLen, gapVert, gapVertDepth+.1], anchor=TOP-BACK);
            up(insertDepth+frontDepth-gapVertDepth+gapHor) cuboid([gapLen, gapHorDepth+.1, gapHor], anchor=TOP-BACK);
        }
        if(flatSide) back(hexHeight/2-gapHorDepth-.1) up(insertDepth+frontDepth+.2) cuboid([gapLen+1,gapVertDepth,insertDepth], anchor=TOP-BACK);
    }
}

module tabBumps(bumpHeight,hexHeight,insertDepth,frontDepth,bumpLen,bumpAng) {
    leftshift=bumpHeight;
    rot_copies(n= 6, v=UP, delta=[0,hexHeight/2,0]) up(insertDepth+frontDepth-bumpLen) rotate([90,0,90]) right_half() left(leftshift) rounded_prism(teardrop2d(r=bumpHeight*2, ang=bumpAng, cap_h=bumpLen+sqrt((2*bumpHeight)^2-leftshift^2), $fn=36), h=bumpLen);
}
module hexCutout(innerHexHeight,cutDepth=0.4,lineWidth=1) {
    tube(h=cutDepth, od=2/sqrt(3)*(innerHexHeight+lineWidth),id=2/sqrt(3)*(innerHexHeight), anchor=BOTTOM, $fn=6);
}
module sideFlattener(hexHeight, fullInsertDepth) {
    down(0.2) back(hexHeight/2) cuboid([hexHeight*2, hexHeight, fullInsertDepth*1.5], anchor=BOTTOM-BACK);
}




// Component testing lines. Uncomment to view individual element with default size

//insert(hexHeight=20,insertDepth=7.67,frontDepth=2,frontExtension=1);
//tabBumps(bumpHeight=0.5,hexHeight=20,insertDepth=7.67,frontDepth=2,bumpLen=1.7,bumpAng=20);
//tabsCutout(hexHeight=20,gapHorDepth=1.6,insertDepth=7.67,frontDepth=2,gapLen=8,gapVert=1,gapVertDepth=3.5,gapHor=0.8,flatSide=true);
//color("red") insertHole();
//hexCutout(innerHexHeight=13.40+1.55);
//sideFlattener(hexHeight = 20, fullInsertDepth=7.67+2);

// Final module testing lines. Uncomment to view how different options generate different versions of the insert.
//hws_insert();
//hws_insert(flatSide=false);
//hws_insert(flatSide=false, centerHole=true);
//hws_insert(flatSide=false, centerHole=true, frontDecoration=true);

//hws_insert_n_vert(blanks=1);
//hws_insert_n_hor();
//hws_insert_rail();