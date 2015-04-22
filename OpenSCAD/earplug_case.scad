thickness = 2;
lip = 1;
outside = 27;
height = 12;


module box() {
  inside = outside - 2 * thickness;
  difference () {
    cube([outside, outside, height], false);
    union () {
      translate([thickness, thickness, thickness]) 
        cube([inside, inside, height], false);
      translate([lip, lip, height - 2 * lip])
        cube([outside - 2 * lip, outside - 2 * lip, lip], false);
    };
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

wiggle = 0.1;
module lid() {
  lip_gap = thickness + wiggle;
  lip_size = outside - 2 * lip_gap;
  bump_size = lip - wiggle;
  cube([outside, outside, thickness], false);
  difference () {
    translate([lip_gap, lip_gap, thickness]) 
      cube([lip_size, lip_size, thickness + lip], false);
    translate([lip_gap + lip, lip_gap + lip, thickness]) 
      cube([lip_size - 2 * lip, lip_size - 2 * lip, thickness + lip], false);
  };
  
  bump_h = 1.5 * thickness + lip;
  translate ([outside - lip_gap, outside / 2, bump_h]) {bump(bump_size, 0);};
  // translate ([outside / 2, outside - lip_gap, bump_h]) {bump(bump_size, 1);};
  // translate ([lip_gap, outside / 2, bump_h]) {bump(bump_size, 2);};
  // translate ([outside / 2, lip_gap, bump_h]) {bump(bump_size, 3);};

};


translate ([1.1 * outside, 0, 0]) lid();

box();