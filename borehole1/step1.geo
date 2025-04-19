// Gmsh script to generate a 1D radial mesh (line from Rw to R0)

Rw = 0.1;     // Inner radius (m)
R0 = 100.0;   // Outer radius (m)
n = 100;      // Number of elements

// Define 1D points
Point(1) = {Rw, 0, 0, 1.0};
Point(2) = {R0, 0, 0, 1.0};

// Define line between them
Line(1) = {1, 2};

// Make it structured (transfinite)
Transfinite Line{1} = n Using Progression 1;

// Tell Gmsh to only generate 1D elements
Mesh.Dimension = 1;
