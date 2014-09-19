use <lib/honeycomb.scad>;
//honeycomb(length, width, height, cell_size, wall_thickness);

use_hex_center = 0;

size = 75;
height = 1.5;
outer_ring = 12;
indents = 7;

debug_sizing = false;
// height = 0.8;

module center_section (use_hex_center)
{
  if (use_hex_center)
    translate(v = [0, 0, height/2])
      linear_extrude(height = height, center = true, convexity = 10, twist = 0, slices = 1)
        circle($fn = 0.5, d = size);
  else
   cylinder(h=height, d=size);
}

// Ring around the edge
module edge_ring(height) {
  intersection() {
    // Cut out a bit on the edges for the container indentations
    rotate([0,0,30]) cube([size + outer_ring - indents, size + outer_ring, height * 2], true);
    // The outside ring less the insides
    difference(){
      cylinder(h=height, d=size+outer_ring, $fs=0.05);
      center_section(use_hex_center);
    }
  }
}

edge_ring(height);

if (debug_sizing)
  translate([(size+outer_ring/2)/2 - use_hex_center*outer_ring/2.5, 0, height]) 
    cylinder(h=5, r1=2, r2=2, center=false, $fs=0.3);


// Honeycomb
if (! debug_sizing) {
  intersection() {
    translate(v = [-size/2, -size/2, height/2])
      honeycomb(size, size, height, 10, 2);
    center_section(use_hex_center);
  }

  // Feet
  for (r=[0:60:300]) 
    rotate(r + use_hex_center * 30) 
      translate([(size+outer_ring/2)/2 - use_hex_center*outer_ring/2.5, 0, height]) 
        cylinder(h=height*4, r1=3, r2=2, center=false, $fs=0.3);
}

