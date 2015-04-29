thickness = 1;
outside = 32;
height = 18;

/*
lip = 1;

module box() {
  inside = outside - 2 * thickness;
  difference () {
    cube([outside, outside, height], false);
    translate([thickness, thickness, thickness]) 
      cube([inside, inside, height], false);
  };
};

module bump (size, rot) {
  rotate([0,0,90*rot]) { 
    intersection() {
      sphere(size, $fn=20);
      translate ([size * 2,0,0]) cube([size*4,size*4,size*4], true);
    };
  };
};


module wedge () {
  base = thickness / 8;
  translate ([-thickness / 2, -base, 0])
    intersection () {
      rotate ([-15, 0, 0]) cube ([thickness, thickness / 2, thickness], false);
      cube ([thickness, base, thickness], false);
  };
};

wiggle = 0.1;
module lid() {
  // How far to shift the lip
  lip_gap = thickness + wiggle;
  // Diameter of lip
  lip_size = outside - 2 * lip_gap;
  // bump_size = lip - wiggle;
  
  // The base of the lid  
  translate ([-thickness / 2, -thickness / 2, 0]) 
    cube([outside + thickness, outside + thickness, thickness], false);
    
  // The lip
  difference () {
    translate([lip_gap, lip_gap, thickness]) 
      cube([lip_size, lip_size, thickness + lip], false);
    translate([lip_gap + lip, lip_gap + lip, thickness]) 
      cube([lip_size - 2 * lip, lip_size - 2 * lip, thickness + lip], false);
      
  };

  // A locking wedge
  translate([outside / 2, lip_gap, thickness]) wedge();
  translate([outside / 2, lip_gap + lip_size, thickness]) rotate([0,0,180]) wedge();
  
  bump_h = 1.5 * thickness + lip;
  // translate ([outside - lip_gap, outside / 2, bump_h]) {bump(bump_size, 0);};
  // translate ([outside / 2, outside - lip_gap, bump_h]) {bump(bump_size, 1);};
  // translate ([lip_gap, outside / 2, bump_h]) {bump(bump_size, 2);};
  // translate ([outside / 2, lip_gap, bump_h]) {bump(bump_size, 3);};

};


// translate ([1.1 * outside, 0, 0]) lid();
// box();

*/

module round_box(rad) {
  $fn = 60;
  hull() {
    translate ([0 + rad, 0 + rad, 0]) circle(r=rad);
    translate ([outside + rad, 0 + rad, 0]) circle(r=rad);
    translate ([0 + rad, outside + rad, 0]) circle(r=rad);
    translate ([outside + rad, outside + rad, 0]) circle(r=rad);
  };
};

r=3;
module box (r) {
  // Base
  linear_extrude(thickness) round_box(r);

  // Walls
  linear_extrude(height) {
    difference() {
      round_box(r);
      offset(r=-thickness) { round_box(r); };
    };
  };
};
  
module lid (r) {
  // Base
  linear_extrude(thickness) offset(thickness) round_box(r);
  // Lip
  linear_extrude(thickness * 2.5) difference() {
    offset(-thickness * 1.5) round_box(r);
    offset(-thickness * 2.5) round_box(r);
  };
  // Inside
  difference () {
    translate ([outside/2 + r, outside/2 + r, thickness])
      cylinder (r1 = (outside + thickness + r)/2, r2 = (outside + r)/2, h = thickness * 1.5, $fn = 150);
    linear_extrude(thickness * 2.6) offset(-thickness * 1.5) round_box(r);
  };
};

// translate ([outside * 2.3 + r*2, 0, height + thickness * 2]) rotate ([0, 180, 0]) lid(r);
translate ([4, 0, 0]) union() {
  lid(r);
  translate ([outside * 1.3, 0, 0]) box(r);
};

cube ([1, outside, 0.5]);


