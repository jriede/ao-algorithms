// aoa/convex-hull
// https://github.com/jriede/ao-algorithms/convex-hull
// jlenke, 2026-01-09

final int COUNT = 16; // max number of points
PVector[] pts; // points to find convex hull for

ArrayList<qhPoint> hull = new ArrayList<qhPoint>();
ArrayList<divLine> lines = new ArrayList<divLine>();
ArrayList<qhPoint> points = new ArrayList<qhPoint>();

ArrayList<qhPoint> left = new ArrayList<qhPoint>();
ArrayList<qhPoint> right = new ArrayList<qhPoint>();

int hullpts, i, xmin, xmax, curLine, idist; 
float fxmin, fxmax, dist;

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
  
  
  
}

void init() {
  qhPoint ptt;
  
  // 1. find points with min(x), max(x) (p1, p2)
  // find min(x)
  xmin = 501;
  fxmin = 501;
  for (i = 0; i < points.size(); i++) {
    ptt = points.get(i);
    if (ptt.getPos().x < fxmin) {
      xmin = i;
      fxmin = ptt.getPos().x;
    }
  }
   //println("xmin: ", xmin, ", ", fxmin);
  
  // find max(x)
  xmax = 0;
  fxmax = 0;
   for (i = 0; i < points.size(); i++) {
    ptt = points.get(i);
    if (ptt.getPos().x > fxmax) {
      //println("xmax: ", xmax, ", ", fxmax);
      xmax = i;
      fxmax = ptt.getPos().x;
    }
  }
  println("xmin = ", xmin, ", xmax = ", xmax);
  
  
  hull.add(new qhPoint(pts[xmin]));
  hull.add(new qhPoint(pts[xmax]));
  
  // 2. line p1-p2
  divLine lin1 = new divLine(new PVector(pts[xmin].x, pts[xmin].y), 
  new PVector(pts[xmax].x, pts[xmax].y));
  lines.add(lin1);
  
  // remove hull points from points arraylist
  points.remove(xmin);
  points.remove(xmax);
  printInfo("after pts remove");
 
}

int getMaxDist(int cline, ArrayList<qhPoint> ptlist ) {
  // cline == current line
  int idi = 100000;
  float dist = 0;
  println("cline:  ", cline);
  
  for (i = 0; i < ptlist.size(); i++) {
   
    if (distance(cline, ptlist.get(i)) > dist) {
      idi = i;
      dist = distance(cline, ptlist.get(i));
    }
  }
  
  //println("cur max dist = ", idist, ", ", dist );
  return idist;
}

void printInfo(String txt) {
  println(txt);
  println("# lines: ", lines.size());
  println("# points: ", points.size());
  println("# hull: ", hull.size());
  
  println("# right: ", right.size());
  println("# left: ", left.size());
}

void sorty(int curLine) {
  int cl = curLine;
  float ang; // angle between
  float lang; // line angle
  PVector v1, v2;
  // 3. divide points into left & right of line
  // foreach point still in the game: 
  // sort (left or right of line)
  printInfo("in sorty()");
  for (i = 0; i < points.size(); i++) {
   qhPoint pt = points.get(i);
   divLine curl = lines.get(cl);
   v1 = curl.getVec();

   float x2 = pt.getPos().x - curl.getp1().x;
   float y2 = pt.getPos().y - curl.getp1().y;
   
   v2 = new PVector(x2, y2);
   // calculate angle between current line and pt
   lang = curl.getAngle();
   ang = v2.heading();
   //println("lang, ang, Delta: ", degrees(lang), ", ", degrees(ang), ", ", degrees(ang) - degrees(lang));
   
   if(degrees(ang) - degrees(lang) < 0) {
     pt.setColor(0,255,0);
     left.add(pt);
   }
   else {
     pt.setColor(0,0,255);
     right.add(pt);
   }
  }

}

void draw() {
  noLoop();
  noStroke();
  fill(102);
  
  for (i = 0; i < points.size(); i++) {
   qhPoint pt = points.get(i);
    fill(102);
    circle(pt.getPos().x, pt.getPos().y, 4);
    text(str(i), pt.getPos().x + 3, pt.getPos().y);
  }  
  saveFrame("01.png");
  this.init();
  
  strokeWeight(2);
  stroke(255, 44, 44);
  line(lines.get(0).p1.x, lines.get(0).p1.y, lines.get(0).p2.x, lines.get(0).p2.y);
  saveFrame("02.png");
  
  sorty(curLine);
  printInfo("after sorty()");
  
  for (i = 0; i < points.size(); i++) {
   qhPoint pt = points.get(i);
    fill(pt.getColor());
    stroke(pt.getColor());
    circle(pt.getPos().x, pt.getPos().y, 4);
    //line(lines.get(0).p1.x, lines.get(0).p1.y, pt.getPos().x, pt.getPos().y);
  }
  saveFrame("03.png");
  
  idist = getMaxDist(0, left);
  qhPoint pt = points.get(idist);
  stroke(255, 30, 30);
  circle(pt.getPos().x, pt.getPos().y, 8);
  saveFrame("04.png");
}


float distance(int l, qhPoint pt) {
  // d (p, line(a,vec(u)) = || AP x u || / || u || where AP = P-A
  divLine line = lines.get(l);
  PVector ap = new PVector(pt.getPos().x - line.getp1().x, pt.getPos().y - line.getp1().y);
  PVector u = pt.getPos();
  PVector crs = ap.cross(u);
  float d = crs.mag() / u.mag();
  //print("distance: ", d);
  return d;
}

class divLine { 
  PVector p1, p2, p3;
  float angle;
  
  divLine (PVector pp1, PVector pp2) {  
    p1 = new PVector(pp1.x, pp1.y); 
    p2 = new PVector(pp2.x, pp2.y);  
    p3 = new PVector(pp2.x - pp1.x, pp2.y - pp1.y);
    //angle = tan((pp2.y -pp1.y)/(pp2.x-pp1.x));
    angle = p3.heading();
    print("line angle = ", degrees(angle));
  } 
  
  PVector getp1() {
    return this.p1;
  }
  
  PVector getp2() {
    return this.p2;
  }
  
  PVector getVec() {
    return this.p3;
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
  
