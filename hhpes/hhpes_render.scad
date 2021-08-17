include <hhpes_data.scad>;

module draw_shape(x=.035) { cube([2*x,2*x,x]); }

size = len(data_array)-1;

for (i = [0 : size]) {
    translate(data_array[i]) { 
        draw_shape();
    }
}
