base = 100;
height=30;
embossed=2;

base_offset=25;

difference(){
  intersection(){
    sphere(d=base, center=true, $fa=5);
    translate([0,0,(height+base_offset)/2]) 
      cube([base,base, height-base_offset], center=true);
  }
  translate([0,0,height-embossed]) cylinder(d=base*0.75, h=embossed, $fa=5);
}


module letter_e() {
  height=10;
  width=6.5;
  thickness=1.5;
  translate([-width/2, -height/2])
    linear_extrude(height = 1, center = false) 
      polygon([[0,0], [0,height], [width,height], 
        [width, height-thickness], [thickness, height-thickness],
        [thickness, (height+thickness)/2], 
        [width-thickness/2, (height+thickness)/2],
        [width-thickness/2, (height-thickness)/2],
        [thickness, (height-thickness)/2],
        [thickness,thickness], [width,thickness], [width,0]]);
}

translate([0, 0, height-embossed]) scale([5,5,embossed]) color("red") letter_e();