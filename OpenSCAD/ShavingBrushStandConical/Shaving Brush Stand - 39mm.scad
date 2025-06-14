height = 90;
width_base = 65;
width_opening = 40;
delta = 1;
wall = 2.5;
cutout = 40;
support_len = 10;
arm_cutout = 15;
arm_angle = 7;
lip_r = 1;
$fn=120;


difference () {
    union () {
        // Main cone
        cylinder(height, d1=width_base, d2=width_opening, center=true);
        // Support arms
        translate([0, 0, height / 2])
            rotate([0, -arm_angle, 0])
                translate([0, 0, -support_len / 2]) difference () {
                    // Wall
                    translate([support_len / 2, 0, 0])
                        cube([support_len, width_opening, support_len], center=true);
                    // Inner space between walls
                    translate([support_len / 2 + delta, 0, delta])
                        cube([support_len + 2 * delta, width_opening - wall, support_len + 2 * delta], center=true);
                    // Rounded cutout
                    translate([support_len + arm_cutout * 0.12, 0, arm_cutout * -0.28])
                        rotate([90, 0, 0])
                            cylinder(width_opening + 2 * delta, d=arm_cutout, center=true);
                }
    }
    // Removed from main cone
    union () {
        // Cone inside
        translate([0, 0, -delta])
            cylinder(height + 2 * delta, d1=width_base - wall, d2=width_opening - wall, center=true);
        // Side cut outs
        for (i = [0:3]) {
            rotate([0, 0, 90 * i])
                translate([width_base / 2, 0, -delta])
                    cylinder(height + 2 * delta, d1=cutout, center=true);
        }
        // Opening for inserting brush
        translate([+width_opening / 2, 0, -delta])
            cube([width_opening, width_opening - wall, height + 2 * delta], center=true);
    }
}

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
    rotate([0, -arm_angle, 0]) {
        for (i = [-1, 1])
            translate([support_len / 2, i * (width_opening / 2 - lip_r), 0])
                rotate ([0, 90, 0])
                    cylinder(support_len, r=lip_r, center=true);
    }
}