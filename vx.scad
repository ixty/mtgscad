double_sleeve = false;
card_x = 68;
card_y = 94;
card_z = double_sleeve ? .75 : 2/3;
card_count = 120;
flip=false;
eps = 0.01;
ANG = 15;
mag_h=5.2;
mag_d=5.2;
mag_zoff=.6;
border = mag_d + 3*.4 + 3*.4;

cards_hole = flip ? [card_x, card_y, card_z * card_count] : [card_x, card_z * card_count, card_y];
border_vec = [ 2*border, 2*border, 2];

module cardshole()
{
    color("cyan")
    cube(cards_hole, center=true);
    
    color("red")
    translate([0, -.5*cards_hole[1], 0])
    rotate([90, 0, 0])
    linear_extrude(eps)
    text("cards", halign="center");
}

module box()
{
    color("lime")
    cube(cards_hole + border_vec, center=true);
}

module shape(ang=ANG, brd_z=2)
{
    dims = cards_hole + border_vec;
    voff = sin(ang) * .5*dims[2];

    pts = [
        [-.5*dims[1], -.5*dims[2]],
        [-.5*dims[1], -voff],
        [-.5*dims[1] + .5*border_vec[0], -voff],
        
        [+.5*dims[1] - .5*border_vec[0], +voff],
        [+.5*dims[1], +voff],
        [+.5*dims[1], -.5*dims[2]],
    ];
    
    difference()
    {
        translate([-.5*dims[0], 0, 0])
        rotate([90, 0, 90])
        linear_extrude(dims[0])
        polygon(pts);
        
        cardshole();
        
        color("yellow")
        {
            // lower left magnet
            translate([
                -.5*dims[0] + .25*border_vec[0],
                -.5*dims[1] + .25*border_vec[1],
                -voff - mag_h - mag_zoff
            ])
            cylinder(h=mag_h, d=mag_d, $fn=32, center=false);
            
            // lower right magnet
            translate([
                +.5*dims[0] - .25*border_vec[0],
                -.5*dims[1] + .25*border_vec[1],
                -voff - mag_h - mag_zoff
            ])
            cylinder(h=mag_h, d=mag_d, $fn=32, center=false);

            // upper left magnet
            translate([
                -.5*dims[0] + .25*border_vec[0],
                +.5*dims[1] - .25*border_vec[1],
                +voff - mag_h - mag_zoff
            ])
            cylinder(h=mag_h, d=mag_d, $fn=32, center=false);
            
            // upper right magnet
            translate([
                +.5*dims[0] - .25*border_vec[0],
                +.5*dims[1] - .25*border_vec[1],
                +voff - mag_h - mag_zoff
            ])
            cylinder(h=mag_h, d=mag_d, $fn=32, center=false);
        }
    }
}

module toptext()
{
    translate([0, 0, - .5*cards_hole[2] - .5*border_vec[2] + mag_zoff - eps])
    rotate([180, 0, 0])
    {
        linear_extrude(mag_zoff)
        union()
        {
            translate([0, 16])
            text("The Master", size=10, halign="center", font="Matrix:style=Bold");

            translate([0, 6])
            text("of Keys", size=10, halign="center", font="Matrix:style=Bold");

            translate([0, -30])
            text("\ue9dc", size=32, halign="center", font="Keyrune:style=Regular");
            
            // keyrune sets
//          text("\ue600", size=14, halign="center", "magic\\-font:style=font");        
        }
    }
}

color("white")
difference()
{
    shape();
    toptext();
}
color("black")
toptext();

color("white")
translate([cards_hole[0] + 2 * border_vec[0], 0, 0])
shape();

//cardshole();

//color("#aabbcc80")
//translate([0, 0, 20])
//rotate([180, 0, 0])
//shape();

//difference()
//{
//    rotate([90, 0, 0])
//    shape(cards_hole);
//
//    color("cyan")
//    translate([border, -border, 0])
//    rotate([90, 0, 0])
//    cube(cards_hole);
//
//    voff = sin(ANG) * .5*cards_hole[0];
//    mag_z_low = .5*cards_hole[1] - voff - mag_h - mag_zoff;
//    mag_z_high = .5*cards_hole[1] + voff - mag_h - mag_zoff;
//
//    color("yellow")
//    translate([.5*border, -border * .5, mag_z_low])
//    cylinder(h=mag_h, d=mag_d, $fn=32);
//
//    color("yellow")
//    translate([.5*border, -border * .5 - cards_hole[2] - border, mag_z_low])
//    cylinder(h=mag_h, d=mag_d, $fn=32);
//
//    color("yellow")
//    translate([.5*border + cards_hole[0] + border, -border * .5, mag_z_high])
//    cylinder(h=mag_h, d=mag_d, $fn=32);
//
//    color("yellow")
//    translate([.5*border + cards_hole[0] + border, -border * .5 - cards_hole[2] - border, mag_z_high])
//    cylinder(h=mag_h, d=mag_d, $fn=32);    
//}
//
//
//difference()
//{
//    color("pink")
//    rotate([90, 0, 0])
//    translate([card_x + 2*border, cards_hole[1]])
//    rotate([0, 0, 180])
//    shape(cards_hole);
//
//    color("cyan")
//    translate([border, -border, 0])
//    rotate([90, 0, 0])
//    cube(cards_hole);
//}
//
