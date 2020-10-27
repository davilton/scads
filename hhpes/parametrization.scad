/* EXAMPLE OF 3D PARAMETRIZATION WITH OPENSCAD
© 2018 Antonio Bueno
https://github.com/atnbueno

The content of this file is licensed under the terms of the MIT
license: <https://opensource.org/licenses/MIT>

DESCRIPTION: An example of 3D parametrization a.k.a. how to wrap
a bidimentional interval around a 3D shape. The code below makes
a weak attempt to minimize the distortion of the triangulation, 
choosing between the two possible diagonals of each rectangle.

Last modification: 2018-03-29
*/

// configuration
x_min = -180;
x_max = 180;
y_min = -180;
y_max = 180;

// example of parametrization found at tex.stackexchange.com/questions/192513/
function f(x,y) = [
    (4+(sin(4*(x+2*y))+1.25)*cos(x))*cos(y),
    (4+(sin(4*(x+2*y))+1.25)*cos(x))*sin(y),
    ((sin(4*(x+2*y))+1.25)*sin(x))
];

$fn = 100;
x_steps = $fn; // this should be a positive integer
y_steps = $fn; // this should be a positive integer

// variables for code readability
x_step = (x_max-x_min)/x_steps;
x_values = [x_min:x_step:x_max+x_step/2]; // +x_step/2 ensures x_max is reached
y_step = (y_max-y_min)/y_steps;
y_values = [y_min:y_step:y_max+y_step/2]; // +y_step/2 ensures y_max is reached

// points to move
points = [ for (y = y_values, x = x_values) f(x, y) ];
echo(str(len(points), " points"));

// faces using those points
lower_triangles = [ for (i = [1:x_steps], j = [1:y_steps])
    if (norm(points[i+(x_steps+1)*(j-1)]-points[i-1+(x_steps+1)*j]) < norm(points[i-1+(x_steps+1)*(j-1)]-points[i+(x_steps+1)*j]))
        [i-1+(x_steps+1)*(j-1), i+(x_steps+1)*(j-1), i-1+(x_steps+1)*j]
    else
        [i-1+(x_steps+1)*(j-1), i+(x_steps+1)*(j-1), i+(x_steps+1)*j] // middle edge flipping
];
upper_triangles = [ for (i = [1:x_steps], j = [1:y_steps])
    if (norm(points[i+(x_steps+1)*(j-1)]-points[i-1+(x_steps+1)*j]) < norm(points[i-1+(x_steps+1)*(j-1)]-points[i+(x_steps+1)*j]))
        [i+(x_steps+1)*(j-1), i+(x_steps+1)*j, i-1+(x_steps+1)*j]
    else
        [i-1+(x_steps+1)*(j-1), i+(x_steps+1)*j, i-1+(x_steps+1)*j] // middle edge flipping
];
triangles = concat(lower_triangles, upper_triangles);
echo(str(len(triangles), " faces"));

// draw result of parametrization
polyhedron(points, triangles);
