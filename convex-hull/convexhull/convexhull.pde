// aoa/convex-hull
// https://github.com/jriede/ao-algorithms/convex-hull
// jlenke, 2026-01-06

final int COUNT = 20; // max number of points
PVector[] pts; // points to find convex hull for

ArrayList<qhPoint> hull = new ArrayList<qhPoint>();
ArrayList<divLine> lines = new ArrayList<divLine>();
ArrayList<qhPoint> points = new ArrayList<qhPoint>();

ArrayList<qhPoint> left = new ArrayList<qhPoint>();
ArrayList<qhPoint> right = new ArrayList<qhPoint>();

int hullpts, i, xmin, xmax, curLine; 
float fxmin, fxmax;

void setup() {
  size(500, 500);
  background(255);
  
  pts = new PVector[COUNT];
  hullpts = 0;
  curLine = 0;
  
  // set up points
  for (i=0; i<COUNT; i++) {
    pts[i] = new PVector();
    pts[i].x = random(500);
    pts[i].y = random(500);
  }
  
  // set up points (obj)
  for (i=0; i<COUNT; i++) {
    points.add(new qhPoint(pts[i]));
  }
  
  // 1. find points with min(x), max(x) (p1, p2)
  // find min(x)
  xmin = 501;
  fxmin = 501;
  for (i=0; i<COUNT; i++) {
    //println(fxmin, xmin);
    if (pts[i].x < fxmin) {
      xmin = i;
      fxmin = pts[i].x;
      //println(xmin);
    }
  }
  
  // find max(x)
  xmax = 0;
  fxmax = 0;
  for (i=0; i<COUNT; i++) {
    //println(fxmax, xmax);
    if (pts[i].x > fxmax) {
      xmax = i;
      fxmax = pts[i].x;
      //println(xmax);
    }
  }
  
  hull.add(new qhPoint(pts[xmin]));
  hull.add(new qhPoint(pts[xmax]));
  
  // 2. line p1-p2
  divLine lin1 = new divLine(new PVector(pts[xmin].x, pts[xmin].y), 
  new PVector(pts[xmax].x, pts[xmax].y));
  lines.add(lin1);
  // remove hull points from points arraylist
  points.remove(xmin);
  points.remove(xmax);
  
  
  println("# lines: ", lines.size());
  println("# points: ", points.size());
  println("# hull: ", hull.size());
  
  
  findHull(curLine);

}

void findHull(int curLine) {
  int cl = curLine;
  float ang;
  PVector v1, v2;
  // 3. divide points into left & right of line
  // foreach point still in the game: 
  // sort (left or right of line)
  // left: green, right: blue// 3. divide points into left & right of line
  println("# lines: ", lines.size());
  println("# points: ", points.size());
  println("# hull: ", hull.size());
  for (i = 0; i < points.size(); i++) {
   qhPoint pt = points.get(i);
   divLine curl = lines.get(cl);

   //
   float x1 = curl.getp2().x - curl.getp1().x;
   float y1 = curl.getp2().y - curl.getp1().y;
   float x2 = pt.getPos().x - curl.getp1().x;
   float y2 = pt.getPos().y - curl.getp1().y;
   
   v1 = new PVector(x1, y1);
   v2 = new PVector(x2, y2);
   // calculate angle between current line and pt
   println ("headings: ", v1.heading(), v2.heading());
   //ang = tan( (pt.getPos().x - curl.getp1().x) / (pt.getPos().y - curl.getp1().y));
   ang = v2.heading();
   //println("angle: " , degrees(ang));
   
 
   if(degrees(ang) < degrees(curl.getAngle()) ) {
     pt.setColor(0,255,0);
     right.add(pt);
   }
   else {
     pt.setColor(0,0,255);
     left.add(pt);
   }
  }

}

void draw() {
  noLoop();
  noStroke();
  fill(102);
  
  for (i = 0; i < points.size(); i++) {
   qhPoint pt = points.get(i);
    fill(pt.getColor());
    stroke(pt.getColor());
    circle(pt.getPos().x, pt.getPos().y, 4);
    line(lines.get(0).p1.x, lines.get(0).p1.y, pt.getPos().x, pt.getPos().y);
  }
  
  saveFrame("01.png");
  
  strokeWeight(2);
  stroke(20, 44, 144);
  //println(lines.get(0).p1.x);
  line(lines.get(0).p1.x, lines.get(0).p1.y, lines.get(0).p2.x, lines.get(0).p2.y);
  saveFrame("02.png");
}


class divLine { 
  PVector p1, p2;
  float angle;
  
  divLine (PVector pp1, PVector pp2) {  
    p1 = new PVector(pp1.x, pp1.y); 
    p2 = new PVector(pp2.x, pp2.y);  
    angle = tan((pp2.y -pp1.y)/(pp2.x-pp1.x));
    print("line angle = ", degrees(angle));
  } 
  
  PVector getp1() {
    return this.p1;
  }
  
  PVector getp2() {
    return this.p2;
  }
  
  float getAngle() {
    return this.angle;
  }
  
} 

// Quick Hull Points have positions, colors, are right/left of line n, ...
class qhPoint{
  PVector pos;
  color col;
  int inHull; // is this a hull point? (0-no, 1-yes)
  int hullPos; // position within hull polygon (1 .. n)
  int inSet; // still part of the investigation or already dropped? (0-no, 1-yes)
  int side; // 0 - r, 1 - l
  
  qhPoint (PVector p) {
    pos = new PVector(p.x, p.y);
    col = color(0, 0, 0);
    inHull = 0;
    inSet = 1;
  }
  
  PVector getPos() {
    return this.pos;
  }
  
  void setSide(int k) {
    this.side = k; // 0 - r, 1 - l
  }
  
  color getColor() {
    return this.col;
  }
  
  void setColor(int r, int g, int b) {
    this.col = color(r,g,b);
  }
  
  int getInHull() {
    return this.inHull;
  }
  
  int getInSet() {
    return this.inSet;
  }
}
  
