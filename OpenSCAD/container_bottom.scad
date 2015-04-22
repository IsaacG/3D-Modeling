use <lib/honeycomb.scad>;
//honeycomb(length, width, height, cell_size, wall_thickness);

size = 80;
cell_size = 10;
height = 1.5;
outer_ring = 12;
indents = outer_ring/2;

module center_section () { cylinder(h=height, d=size); }

// Ring around the edge
module edge_ring(height) {
  intersection() {
    // Cut out a bit on the edges for the container indentations
    translate([0,0,height/2])
      cube([size + outer_ring - indents, size + outer_ring, height], true);
    // The outside ring less the insides
    difference(){
      cylinder(h=height, d=size+outer_ring, $fs=0.05);
      center_section();
    }
  }
}

// Honeycomb
intersection() {
  // Shift by 9 to get a honeycomb centered in the middle
  translate(v = [-size/2 - 0.7, -size/2 - 9, height/2])
    honeycomb(size + cell_size, size + cell_size, height, cell_size, 2);
  center_section();
}

rotate([0,0,60]) union() {
  edge_ring(height);

  // Feet
  for (r=[30:60:330]) 
    rotate(r) 
      translate([(size+outer_ring/2)/2-0.2, 0, height]) 
        cylinder(h=height*4, r1=2.9, r2=2, center=false, $fs=0.3);

}