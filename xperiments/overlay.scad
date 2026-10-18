szfb = [2* 41.7, 2* 51.2];
szlr = [2* 35.6, 2* 51.2];
border = 1.2;


module texture(path, size_xyz)
{
    resize(size_xyz)
    {
        difference()
        {
            surface(path, invert=false,);

            color("red")
            translate([0, 0, -1.01])
            cube([20*size_xyz[0], 20*size_xyz[1], 10]);
        }

    }
}

cube([ szfb[0], szlr[0], border ]);

translate([0, border, 0])
rotate([90, 0, 0])
texture("txf.png", [ szfb[0], szfb[1], border ]);

translate([ szfb[0], szlr[0] - border, 0])
rotate([0, 0, 180])
rotate([90, 0, 0])
texture("txb.png", [ szfb[0], szfb[1], border ]);

translate([border, szlr[0], 0])
rotate([0, 0, -90])
rotate([90, 0, 0])
texture("txl.png", [ szlr[0], szlr[1], border ]);

translate([szfb[0] - border, 0, 0])
rotate([0, 0, 90])
rotate([90, 0, 0])
texture("txr.png", [ szlr[0], szlr[1], border ]);

//module xor(){
//    difference(){
//        union(){
//            children(0);
//            children(1);
//        }
//        intersection(){
//            children(0);
//            children(1);
//        }
//    }
//}
//
//intersection()
////xor()
//{
//    rotate([90, 0, 0])
//    texture("txf.png", [100, 100, 1.2]);
//
//    translate([1.2, 0, 0])
//    //translate([0, 1.2, 0])
//    rotate([0, 0, 90])
//    rotate([90, 0, 0])
//    texture("txf.png", [100, 100, 1.2]);
//}
//
//union()
//{
//    rotate([90, 0, 0])
//    texture("txl.png", [100, 100, 1.2]);
//
//    translate([1.2, 0, 0])
//    //translate([0, 1.2, 0])
//    rotate([0, 0, 90])
//    rotate([90, 0, 0])
//    texture("txl.png", [100, 100, 1.2]);
//}
