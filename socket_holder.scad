//drive_size_title = "METRIC 1/4\" DRIVE"; // <TYPE> <SIZE> DRIVE
drive_size_title = "SAE 3/8\" DRIVE"; 
title_size = 5;
offset_x = 2; offset_y = 2;

s = [  
  //[12, "4"],[12, "5"],[12, "5.5"],[12, "6"],[12, "7"],[12.2, "8"],[13, "9"],[14.5, "10"],[16, "11"],[17.75, "12"],[19, "13"],[20.5, "14"] // 1/4 metric
  [17, "1/4"],[17, "5/16"],[17, "3/8"],[17, "7/16"],[18.75, "1/2"],[20.25, "9/16"],[22.5, "5/8"],[24.5, "11/16"],[25.5, "3/4"]
];

cx = tot(len(s)-1, s[len(s)-1][0]) + (len(s))*offset_x; 
cy = 35;
cz = 10;

function tot(n, sum=0) =
  n==0 ? sum : tot(n-1, sum+s[n][0]);

mheight = 1.6; mdiameter = 6; // magnet
cylinder_height = 20;

// font 
fstyle = "Helvetica:style=Bold";
fsize = 4; fheight = 4;

$fn=100;  // facets

function add_up_to(n, sum=0) = 
  n==0 ? sum + offset_x - s[n][0]/2 : add_up_to(n-1, sum + s[n-1][0] + offset_x);

difference() {
  minkowski() { translate([cx/2,0,0]) cube([cx, cy, cz], center=true); sphere(r=.5); }
  
  { // Title front and back
    translate([cx/2,cy/2,0])
       rotate([90,0,180])
        linear_extrude(2) 
          text(drive_size_title, title_size, fstyle, halign="center", valign="center");
    translate([cx/2,-cy/2,0])
      rotate([90,0,0])
        linear_extrude(2) 
          text(drive_size_title, title_size, fstyle, halign="center", valign="center");
  }
  
  for (i = [0:len(s)-1]) {
    size  = s[i][0];
    label = s[i][1];
    translate([add_up_to(i, sum=size), offset_y, -2]) {
      translate([0, -size/2-5, cz/2+2])
        linear_extrude(fheight)
          text(label, fsize, fstyle, halign="center");
      difference()
        cylinder(h=cylinder_height, d=size);
      translate([size/2-3, 0, -1.5])
        cylinder(h=mheight, d=mdiameter);
    }     
  }
}         







