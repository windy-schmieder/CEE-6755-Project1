// === Geometry Parameters ===
Rw = 1;      // well radius
R0 = 20;     // outer boundary radius
H  = 20;     // reservoir thickness

// === Define Points ===
Point(1) = {Rw, 0, 0, 1.0};
Point(2) = {R0, 0, 0, 1.0};
Point(3) = {R0, H, 0, 1.0};
Point(4) = {Rw, H, 0, 1.0};

// === Define Lines and Surface ===
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(10) = {1, 2, 3, 4};
Plane Surface(11) = {10};

// === Refinement Field: Distance from well boundary ===
// We'll refine near the left edge (Points 1 and 4)
Field[1] = Distance;
Field[1].EdgesList = {4};  // nodes near the well

Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = 0.1;        // finest element size near well
Field[2].SizeMax = 5.0;        // coarsest element size far away
Field[2].DistMin = 0.5;        // within this radius
Field[2].DistMax = 1.0;        // beyond this

Background Field = 2;

// === Define Physical Lines (for boundary conditions) ===
Physical Curve("inner")  = {4};  // left (r = Rw)
Physical Curve("outer")  = {2};  // right (r = R0)
Physical Curve("bottom") = {1};  // bottom (z = 0)
Physical Curve("top")    = {3};  // top (z = H)

// === Define Physical Surface (for the domain) ===
Physical Surface("domain") = {11};


// === Mesh Options ===
Mesh.Algorithm = 6; // Delaunay triangulation
Mesh 2;
