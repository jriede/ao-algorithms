// aoa/convex-hull
// https://github.com/jriede/ao-algorithms/convex-hull
// jlenke, 2026-01-05

final int COUNT = 20; // max numnber of points
PVector[] pts; // points to find convex hull for
PVector[] hull; 
PVector[][] lines;

int hullpts, i, xmin, xmax; 
float fxmin, fxmax;

void setup() {
  size(500, 500);
  background(255);
  
  pts = new PVector[COUNT];
  hull = new PVector[COUNT];
  lines = new PVector[COUNT][2];
  hullpts = 0;
  
  // set up points
  for (i=0; i<COUNT; i++) {
    pts[i] = new PVector();
    pts[i].x = random(500);
    pts[i].y = random(500);
  }

  // 1. find points with min(x), max(x) (p1, p2)
  // find min(x)
  xmin = 501;
  fxmin = 501;
  for (i=0; i<COUNT; i++) {
    println(fxmin, xmin);
    if (pts[i].x < fxmin) {
      xmin = i;
      fxmin = pts[i].x;
      println(xmin);
    }
  }
  
  // find max(x)
  xmax = 0;
  fxmax = 0;
  for (i=0; i<COUNT; i++) {
    println(fxmax, xmax);
    if (pts[i].x > fxmax) {
      xmax = i;
      fxmax = pts[i].x;
      println(xmax);
    }
  }
  lines[0][0] = new PVector();
  lines[0][1] = new PVector();
  lines[0][0] = pts[xmin];
  lines[0][1] = pts[xmax];
  
  
  
  // 2. line p1-p2
  

}

void draw() {
  noStroke();
  fill(102);
  
  for (i=0; i<COUNT; i++) {
    circle(pts[i].x, pts[i].y, 3);
  }
  
  strokeWeight(2);
  stroke(20, 255, 44);
  line(lines[0][0].x, lines[0][0].y, lines[0][1].x, lines[0][1].y);
}
