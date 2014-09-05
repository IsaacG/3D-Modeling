module hc_column(length, cell_size, wall_thickness) {
  no_of_cells = floor(length / (cell_size + wall_thickness)) ;

  for (i = [0 : no_of_cells]) {
    translate([0,(i * (cell_size + wall_thickness)),0])
       circle($fn = 6, r = cell_size * (sqrt(3)/3));
  }
}

module honeycomb (length, width, height, cell_size, wall_thickness) {
  no_of_rows = floor(1.2 * length / (cell_size + wall_thickness)) ;

  tr_mod = cell_size + wall_thickness;
  tr_x = sqrt(3)/2 * tr_mod;
  tr_y = tr_mod / 2;
  off_x = -1 * wall_thickness / 2;
  off_y = wall_thickness / 2;
  linear_extrude(height = height, center = true, convexity = 10, twist = 0, slices = 1)
    difference(){
      square([length, width]);
      for (i = [0 : no_of_rows]) {
        assign(x_pos = i * tr_x + off_x, y_pos = (i % 2) * tr_y + off_y)
          translate([x_pos, y_pos, 0])
           hc_column(width, cell_size, wall_thickness);
      }
    }
}
// if (sqrt(pow(i * tr_x + off_x, 2) + pow((i % 2) * tr_y + off_y, 2)) > 100)

//honeycomb(length, width, height, cell_size, wall_thickness);
size=450;
height=15;
outer_ring=60;

module center_section (use_hex_center)
{
  if (use_hex_center)
    translate(v = [0, 0, height/2])
      linear_extrude(height = height, center = true, convexity = 10, twist = 0, slices = 1)
        circle($fn = 6, d = size);
  else
   cylinder(h=height, d=size);
}

use_hex_center = 1;

// Honeycomb
intersection() {
  translate(v = [-size/2, -size/2, height/2]){ honeycomb(size, size, height, 60, 17); }
  center_section(use_hex_center);
}

// Ring around the edge
if (true)
  difference(){
    cylinder(h=height, d=size+outer_ring);
    center_section(use_hex_center);
  }


// z-axis
// cylinder(h=50, r=1, center=false);


// Feet
for (r=[0:60:300]) 
  rotate(r + use_hex_center * 30) 
    translate([(size+outer_ring/2)/2 - use_hex_center*outer_ring/2.5, 0, height]) 
      cylinder(h=height*2.0, r1=outer_ring/4-5, r2=8, center=false);
