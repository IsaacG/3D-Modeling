// brush_width: Brush handle diameter -- the part that sits on the stand.
// height: From the hanging part to the base; allow space for clearance.
// width_base :About the diameter of the bristles when spread open, plus a bit more.

/*
// Omega 10049
brush_width = 39;
height = 90;
width_base = 65;
*/

// Semague 830
brush_width = 28;
height = 62;
width_base = 55;


lip_r = 1;
width_opening = brush_width + 2 * lip_r + 1;
delta = 1;
wall = 2.5;
support_len = 15;
arm_angle = 7;
$fn=120;

module fillet(h, up){
    translate([-(width_base-h-wall)/2, 0, up*(height-h-wall)/2])
    rotate([0,up == 1 ? 90 : 0,0])
    difference() {
        cube([h, width_base, h], true);
        translate([h/2,0,h/2])
        rotate([90,0,0])
        cylinder(h=width_base+wall, r=h, center=true);
    }
}

module stand_walls() {
    // top
    translate([0, 0, height / 2]) {
        cube([width_base, width_base, wall], true);
    };
    // base
    translate([0, 0, -height / 2]) {
        cube([width_base, width_base, wall], true);
    };
    // back
    translate([-width_base / 2, 0, 0]) {
        cube([wall, width_base, height + wall], true);
    };
    fillet(20, -1);
    fillet(15, 1);
};

module top_primary_cutout() {
    // Primary opening
    translate([0, 0, height / 2 - wall]) {
        cylinder(h=wall*2, r=width_opening/2);
    };
    // Square cutout access to opening
    translate([width_opening / 2, 0, height / 2]) {
        cube([width_opening, width_opening, wall * 2], center = true);
    };        
};

module back_side_cuts() {
    // Curved cuts along the sides
    for (i = [-1, 1]) {
        translate([-(width_base / 2 + wall), i * height * .81, 0])
            rotate ([0, 90, 0])
                cylinder(wall*10, r=height * 0.6, true);
    }
};

module support_lip() {
    // Rounded inner lip
    translate([0, 0, height / 2 - lip_r]) {
        // Half torus inside code
        difference () {
            rotate_extrude(convexity = 10)
                translate([(width_opening/2) - lip_r, 0, 0])
                    circle(r = lip_r);
            translate([width_opening / 2 + delta, 0, 0])
                cube([width_opening + 2 * delta, width_opening + delta, 2 * (lip_r + delta)], center=true);
        }
        // Support arms
        for (i = [-1, 1])
            rotate([0, -arm_angle, i * 4]) {
                translate([support_len / 2, i * (width_opening / 2 - lip_r), 0])
                    rotate ([0, 90, 0])
                        cylinder(support_len, r=lip_r, center=true);
        }
    };
};
           
rotate([0, -90, 0])
    difference() {
        union () {
            difference() {
                stand_walls();
                top_primary_cutout();
                back_side_cuts();
            };
            support_lip();
        };
        // Larger opening
        translate([width_base / 2, 0, height / 2 - wall]) {
            cylinder(h=wall*2, r=3 / 4 * width_opening);
    };
};