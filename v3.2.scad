// =========================================================== //
// vars
// =========================================================== //

OBJ = "display";

// "cmdr", "75" or "60"
box_type = "cmdr";

// display
slide       = true;
slide_len   = 20;

// size
in_cardnum      = (box_type == "cmdr" ? 97 : box_type == "75" ? 75 : 60);
in_reserve      = (box_type == "cmdr" ? 16.5 : 0);
no_reserve      = (box_type == "cmdr" ? false : true);

col_base  = "#FAF0DF";
col_light = "#FAF0DF";
col_logo  = "#F4DCB2";

// texture
texture_enable  = false;
texture_front   = "samples/klauth/txf.png";
texture_back    = "samples/klauth/txf.png";
texture_left    = "samples/klauth/txs.png";
texture_right   = "samples/klauth/txs.png";
// texture sizes, cmdr => front[w89 x h106] side[w78 x h106] => 430px x 512px | 376px x 512px
// texture sizes, 75   => front[w78 x h106] side[w59 x h106]


// deckname, top of box
title_enable    = true;
title1_size     = 12;
title2_size     = 12;
title_2lines    = true;
title1_text     = "\ue000\ue003";
title2_text     = "Boros";
title1_offset    = [0, 0];
title1_font     = "magic\\-font:style=font";
title2_font     = "Matrix:style=Bold";
title2_offset    = [0, 0];

// front module, mana logo
// logo_mode       = "";
// logo_mode       = "mana1";
// logo_mode       = "mana2";
// logo_mode       = "set1";
// logo_mode       = "WU";
// logo_mode       = "simic";

logo_mode       = "surface";

logo_mana1_text = "\ue601";
logo_mana1_off  = [0, 0];
logo_set1_text  = "\ue61c";
logo_set1_off   = [-1, -1];

logo_mana2_t1 = "\ue601";
logo_mana2_t2 = "\ue603";

logo_surf_tx = "samples/klauth/klauth-head-bw2.png";

// magnet dims
magnet_height = 2.4;
magnet_diameter = 20.4;

// card thickness is affected by this
double_sleeve = false;

// =========================================================== //
// params
// =========================================================== //

flip = (in_cardnum < 76 && no_reserve);

card_x = 68;
card_y = 94;
card_z = double_sleeve ? .75 : 2/3;
cardsh = card_z * in_cardnum;

engrave = 1.2;
engrave_eps = 0.01;

w_top = magnet_height + .8*2;
w_bot = w_top;
w_side = engrave + 1.2;
w_back = w_top;

eps=0.001;

margin_xy = .4;
margin_z = .2;

topmargin = margin_xy;

inner_magnet_botoffset = 1.0;


flat_inner_x = cardsh + 2*w_side + (no_reserve ? 0 : card_z*(in_reserve) + w_side);
flat_inner_y = card_y + w_top + w_bot;
flat_inner_z = card_x + w_bot;

flip_inner_x = card_x + 2*w_side;
flip_inner_y = card_y + w_top + w_bot;
flip_inner_z = cardsh + w_back;

inner_x = flip ? flip_inner_x : flat_inner_x;
inner_y = flip ? flip_inner_y : flat_inner_y;
inner_z = flip ? flip_inner_z : flat_inner_z;
outer_x = inner_x + 2*w_side + 2*margin_xy;
outer_y = inner_y + w_bot + margin_z;
outer_z = inner_z + 2*w_side + 2*margin_xy;

debug_magnet = false;
debug_height = .41*inner_z;
double_magnet = false;


// reserve vars
cardsh1 = card_z*in_reserve;
cardsh2 = card_z*in_cardnum;

cut_x = card_x + 2*w_side + 2*eps + 2*4;
cut_y = card_y + w_top + w_back + 2*eps;
cut_z = w_side + cardsh1 + eps;

blck_mrgn = .6;
blck_x = 3;
blck_y = .5*w_top;
blck_z = 4;


// =========================================================== //
// common
// =========================================================== //


module magnet()
{
    h=magnet_height;
    d=magnet_diameter;
    translate([0, h, 0])
    if(double_magnet)
    {
        translate([-d*.5, 0, 0])
        rotate([90, 0, 0])
        {
            cylinder(h=h, d=d, $fn=64);
            translate([-d/2, 0, 0])
            cube([d, d/2, h]);
        }

        translate([d*.5, 0, 0])
        rotate([90, 0, 0])
        {
            cylinder(h=h, d=d, $fn=64);
            translate([-d/2, 0, 0])
            cube([d, d/2, h]);
        }
    }
    else
    {
        rotate([90, 0, 0])
        {
            cylinder(h=h, d=d, $fn=64);
            translate([-d/2, 0, 0])
            cube([d, d/2, h]);
        }
    }
}

module coche(height, outeroff=0, inner=true)
{
    h=(height)*.666;
    hm=(height - h)*.5;
    w=h*.3333;

    translate([0, inner ? inner_y : outer_y, .5*height*.3333])
    rotate([90, 0, -90])
    linear_extrude(w_side + (inner?margin_xy:2*margin_xy))
    polygon([
        [0-outeroff, 0-outeroff],
        [w, w],
        [w, 2*w],
        [0-outeroff, 3*w+outeroff],
    ]);
}


module insidecoche(height, outeroff=0, inner=true)
{
    translate([0, w_bot, inner_z])
    rotate([0, 90, 0])
    linear_extrude(w_side+2*eps)
    polygon([
        [0, 0],
        [.26*height, height*.25],
        [.26*height, height*.75],
        [0, height],
    ]);
}


// =========================================================== //
// front logos
// =========================================================== //
module logo_hollow(radius)
{
    translate([.5*outer_x, .5*outer_y, outer_z - (engrave - engrave_eps)])
    cylinder(h=engrave + engrave_eps, r=radius, $fn=64);    
}
module logo_circle(radius)
{
    translate([.5*outer_x, .5*outer_y, outer_z - (texture_enable?engrave-engrave_eps:0)])
    rotate_extrude(convexity=10, $fn=64)
    translate([radius, 0, 0])
    circle(r=engrave, $fn=64);
}

module logo_text_1( text, size, radius, slant, off, font, negative)
{
    translate([.5*outer_x, .5*outer_y, outer_z - (texture_enable?engrave-engrave_eps:0)])
    linear_extrude(.75*engrave + engrave_eps, scale=slant)
    offset(r=.02, chamfer=true)
    translate([off[0], off[1], 0])
    text(text, size=size, halign="center", valign="center", font=font);
}

module logo_mana_1(negative, text=logo_mana1_text, off=logo_set1_off)
{
    if(negative)
        logo_hollow(22);
    else
    {
        logo_text_1(text,24,22,.92,off,"Mana:style=Regular",negative);
        logo_circle(22);
    }
}

module logo_set_1(negative, text=logo_set1_text, off=logo_set1_off) {
    if(negative)
        logo_hollow(22);
    else
    {
        logo_text_1(text,24,22,.92,off,"Keyrune:style=Regular",negative);
        logo_circle(22);
    }
}

module logo_mana_2(negative, t1=logo_mana2_t1, t2=logo_mana2_t2, off=[0,0], fontsz=16) {
    if(negative)
        logo_hollow(22);
    else
    {
        translate([off[0], 0, 0])
        logo_text_1(t1,fontsz,22,.92,[0,0],"Mana:style=Regular",negative);
        translate([off[1], 0, 0])
        logo_text_1(t2,fontsz,22,.92,[0,0],"Mana:style=Regular",negative);

        logo_circle(22);
    }
}

module logo_mana_5(negative, fontsz=11) {
    if(negative)
        logo_hollow(28);
    else
    {
        d = 17;
    
        translate([.0*d, 1.0*d, 0])
        logo_text_1("\ue600",fontsz+1,22,.92,[0,0],"Mana:style=Regular",negative);

        translate([.95*d, 0.31*d, 0])
        logo_text_1("\ue601",fontsz+.5,22,.92,[0,0],"Mana:style=Regular",negative);
        
        translate([.59*d, -.81*d, 0])
        logo_text_1("\ue602",fontsz-.5,22,.92,[0,0],"Mana:style=Regular",negative);

        translate([-.59*d, -.81*d, 0])
        logo_text_1("\ue603",fontsz-.5,22,.92,[0,0],"Mana:style=Regular",negative);

        translate([-.95*d, .31*d, 0])
        logo_text_1("\ue604",fontsz-.5,22,.92,[0,0],"Mana:style=Regular",negative);

        logo_circle(28);
    }
}

module logo_surf(negative, realz=false)
{
    if(negative)
    {

            translate([.5*outer_x, .5*outer_y, outer_z - (engrave - engrave_eps) -.017])
            cylinder(h=engrave + engrave_eps, r=21, $fn=128);    

            translate([.4*outer_x, .5*outer_y, outer_z - 1.5*(engrave) - engrave_eps])
            cylinder(h=.5*engrave + engrave_eps, r=3, $fn=64);

            translate([.6*outer_x, .5*outer_y, outer_z - 1.5*(engrave) - engrave_eps])
            cylinder(h=.5*engrave + engrave_eps, r=3, $fn=64);


    }
    else if(!realz)
    {
        logo_circle(22);
    }
    else
    {
        translate([0, 0, 0 ])
        {
        
            translate([.5*outer_x, .5*outer_y, outer_z - (engrave - engrave_eps)])
            cylinder(h=engrave + engrave_eps, r=21, $fn=64);    

            translate([.4*outer_x, .5*outer_y, outer_z - 1.5*(engrave) - engrave_eps])
            cylinder(h=.5*engrave + engrave_eps, r=2.8, $fn=64);

            translate([.6*outer_x, .5*outer_y, outer_z - 1.5*(engrave) - engrave_eps])
            cylinder(h=.5*engrave + engrave_eps, r=2.8, $fn=64);
        
            difference()
            {
                translate([.5*outer_x, .5*outer_y, outer_z-.17])
                translate([-1.5, -1, 0])
                scale([1, 1, 1])
                resize([33, 33, 1])
                surface(logo_surf_tx, center=true);
                
                translate([.5*outer_x, .5*outer_y, outer_z - (engrave - engrave_eps)])
                cylinder(h=engrave + 2*engrave_eps, r=40, $fn=64);

            }
        }
    }
}

module logo(negative=false)
{
    if(logo_mode == "mana1")
        logo_mana_1(negative);
    else if(logo_mode == "set1")
        logo_set_1(negative);
    else if(logo_mode == "mana2")
        logo_mana_2(negative);
    else if(logo_mode == "surface")
        logo_surf(negative);

    else if(logo_mode == "W")
        logo_mana_1(negative, "\ue600", [.5, 0]);
    else if(logo_mode == "U")
        logo_mana_1(negative, "\ue601", [.1, .1]);
    else if(logo_mode == "B")
        logo_mana_1(negative, "\ue602", [.25, 0]);
    else if(logo_mode == "R")
        logo_mana_1(negative, "\ue603", [.25, .25]);
    else if(logo_mode == "G")
        logo_mana_1(negative, "\ue604", [.25, 0]);

    else if(logo_mode == "WU")
        logo_mana_2(negative, "\ue600", "\ue601", [-8.5, 10.5]);
    else if(logo_mode == "UB")
        logo_mana_2(negative, "\ue601", "\ue602", [-11, 8]);
    else if(logo_mode == "BR")
        logo_mana_2(negative, "\ue602", "\ue603", [-9, 10]);
    else if(logo_mode == "RG")
        logo_mana_2(negative, "\ue603", "\ue604", [-10, 10], 14);
    else if(logo_mode == "GW")
        logo_mana_2(negative, "\ue604", "\ue600", [-10, 10.5], 14);
    else if(logo_mode == "WB")
        logo_mana_2(negative, "\ue600", "\ue602", [-10, 10.5], 14);
    else if(logo_mode == "UR")
        logo_mana_2(negative, "\ue601", "\ue603", [-10.5, 8]);
    else if(logo_mode == "BG")
        logo_mana_2(negative, "\ue602", "\ue604", [-10, 10], 14);
    else if(logo_mode == "RW")
        logo_mana_2(negative, "\ue603", "\ue600", [-10, 10], 14);
    else if(logo_mode == "GU")
        logo_mana_2(negative, "\ue604", "\ue601", [-8.5, 10.5], 14);

    else if(logo_mode == "WUBRG")
        logo_mana_5(negative);

    else if(logo_mode == "azorius")
        logo_mana_1(negative, "\ue90c", [0, 4]);
    else if(logo_mode == "dimir")
        logo_mana_1(negative, "\ue90e", [0, 0]);
    else if(logo_mode == "rakdos")
        logo_mana_1(negative, "\ue913", [0, 1]);
    else if(logo_mode == "gruul")
        logo_mana_1(negative, "\ue910", [0, 0]);
    else if(logo_mode == "selesnya")
        logo_mana_1(negative, "\ue914", [0, 0]);
    else if(logo_mode == "orzhov")
        logo_mana_1(negative, "\ue912", [0, 0]);
    else if(logo_mode == "izzet")
        logo_mana_1(negative, "\ue911", [0, 2]);
    else if(logo_mode == "golgari")
        logo_mana_1(negative, "\ue90f", [0, 0]);
    else if(logo_mode == "boros")
        logo_mana_1(negative, "\ue90d", [0, 0]);
    else if(logo_mode == "simic")
        logo_mana_1(negative, "\ue915", [0, 0]);

    else if(logo_mode == "abzan")
        logo_mana_1(negative, "\ue916", [0, 0]);

    else if(logo_mode == "storm")
        logo_set_1(negative, "\ue95a", [0, 0]);

    else if(logo_mode == "blb")
        logo_set_1(negative, "\ue9cd", [0, 0]);


 }


// =========================================================== //
// inner
// =========================================================== //

module inner()
{
    difference()
    {
        // main box
        color(col_light)
        cube([
            inner_x,
            inner_y,
            inner_z
        ]);
        
        if(debug_magnet)
        {
            translate([-eps, -eps, debug_height - w_side - margin_xy])
            cube([
                inner_x+2*eps,
                inner_y+2*eps,
                inner_z+2*eps
            ]);
        }
        
        color(col_light)
        if(!no_reserve)
        {
            // hole for reserve
            translate([w_side, w_bot, w_back])
            cube([cardsh1, card_y, card_x+eps]);
        
            // hole for cards        
            translate([w_side + cardsh1 + w_side, w_bot, w_back])
            cube([cardsh, card_y, card_x+eps]);
        }
        else
        {
            // hole for cards
            translate([w_side, w_bot, w_back])
            cube([card_x+eps, card_y+eps, cardsh+eps]);
        }

        // hole for magnet
        translate([inner_x/2,
            (w_bot-magnet_height)/2,
            (inner_z)/2
        ])
        magnet();
        
        color(col_logo)
        if(title_enable)
        {
            // title - line 1 : mana symbols
            translate([
                .5*inner_x - title1_offset[0],
                inner_y - engrave,
                .5*inner_z + (title_2lines? 1.25*title2_size:.666*title2_size) + title1_offset[1]
            ])
            rotate([90, 0, 180])
            linear_extrude(engrave + engrave_eps)
            offset(r=.01, chamfer=true)
            text(title1_text, size=title1_size, halign="center", valign="top", font=title1_font);

            // title - line 2 : deck name
            if(title_2lines)
            translate([
                .5*inner_x - title2_offset[0],
                inner_y - engrave,
                .5*inner_z - .333*title2_size + title2_offset[1]
            ])
            rotate([90, 0, 180])
            linear_extrude(engrave + engrave_eps)
            text(title2_text, size=title2_size, halign="center", valign="top", font=title2_font);
        }
        
        // sideholes
        color(col_light)
        translate([-eps, 0, eps])
        insidecoche(inner_y-w_bot-w_top, w_side+2*eps);

        color(col_light)
        if(!no_reserve)
            translate([cardsh1+w_side-eps, 0, eps])
            insidecoche(inner_y-w_bot-w_top, w_side+2*eps);

        color(col_light)
        translate([
            (no_reserve?card_x+w_side:cardsh+w_side+cardsh1+w_side)-eps,
            0,
            eps
        ])
        insidecoche(inner_y-w_bot-w_top, w_side+2*eps);
        
    }

    color(col_light)
    difference()
    {
        union()
        {
            coche(inner_z, 0, true);

            translate([inner_x + w_side + margin_xy, 0, 0])
            coche(inner_z, 0, true);
        }
        
        if(texture_enable)
        {
            // left surface
            translate([
                -(w_side - engrave) - margin_xy - engrave_eps,
                -(outer_y - inner_y),
                -0.5*(outer_z - inner_z)
            ])
    
            translate([0, 0, outer_z])
            rotate([180, 0, 0])
            rotate([0, -90, 180])
            resize([outer_z, outer_y, engrave])
            surface(texture_left, invert=true);
            
            // right surface
            translate([
                inner_x + engrave + margin_xy + engrave_eps,
                -(outer_y - inner_y),
                -0.5*(outer_z - inner_z)
            ])
            rotate([0, -90, 0])
            resize([outer_z, outer_y, engrave])
            surface(texture_right, invert=true);
        }
    }

}



// =========================================================== //
// outer
// =========================================================== //
module outer()
{
    
    color(col_base)
    difference()
    {
        // base outer box
        cube([
            outer_x,
            outer_y,
            outer_z
        ]);
        
        if(debug_magnet)
        {
            translate([-eps, -eps, debug_height])
            cube([
                outer_x+2*eps,
                outer_y+2*eps,
                outer_z+2*eps
            ]);
        }
        

        // hole for inner box
        translate([w_side, w_bot, w_side])
        cube([
            outer_x - 2*w_side,
            outer_y - w_bot + eps,
            outer_z - 2*w_side
        ]);

        // hole for magnet
        magzoffset = no_reserve ?
            (2*w_side + w_bot + cardsh)/2  + margin_xy :
            w_side + (card_x-w_side*.5)*.5 + margin_xy;
        
        translate([
            2 * w_side + (in_reserve ? (cardsh + cardsh1 + w_side)/2 : .5*card_x) + margin_xy,
            (w_bot-magnet_height)/2,
            magzoffset
        ])
        magnet();


        translate([w_side+margin_xy, -topmargin+eps, w_side+margin_xy])
        coche(inner_z, topmargin, false);

        translate([2*w_side+inner_x+3*margin_xy, -topmargin+eps, w_side+margin_xy])
        coche(inner_z, topmargin, false);

        // outer texture substraction
        if(texture_enable && !debug_magnet)
        {
            // top surface
            translate([outer_x-eps, -eps, outer_z - (engrave - engrave_eps)])
            resize([outer_x+2*eps, outer_y+2*eps, engrave ])
            rotate([0, 180, 0])
            surface(texture_front, invert=true);
            
            // bot surface
            translate([-eps, -eps, engrave - engrave_eps])
            resize([outer_x+2*eps, outer_y+2*eps, engrave])
            rotate([0, 0, 0])
            surface(texture_back, invert=true);

            // left surface
            translate([engrave - engrave_eps - eps, -eps, outer_z])
            rotate([180, 0, 0])
            rotate([0, -90, 180])
            resize([outer_z+2*eps, outer_y+2*eps, engrave])
            surface(texture_left, invert=true);

            // right surface
            translate([outer_x - engrave + engrave_eps - eps, -eps, 0])
            rotate([0, -90, 0])
            resize([outer_z+2*eps, outer_y+2*eps, engrave])
            surface(texture_right, invert=true);

        }

        // hole for logo
        logo(true);
    };
    
    if(!debug_magnet)
        color(col_logo)
        logo(false);
    
 }
 
// =========================================================== //
// output
// =========================================================== //

if(OBJ == undef || OBJ == "all" || OBJ == "inner")
    translate([.5*(outer_x-inner_x), eps+(slide?slide_len:0)+w_bot+margin_z, .5*(outer_z-inner_z)])
    inner();

if(OBJ == "outer")
    translate([0, outer_z, 0])
    translate([0, 0, w_top+margin_z])
    rotate([90, 0, 0])
    outer();

if(OBJ == "display" && logo_mode == "surface")
    logo_surf(false, true);

else if(OBJ == undef || OBJ == "all")
    outer();

    
if(OBJ == "display")
{
    translate([0,0,0])
    rotate([90,0,0])
    translate([.5*(outer_x-inner_x), eps++w_bot+margin_z, .5*(outer_z-inner_z) ])
    inner();

    rotate([90,0,0])
    outer();
}

