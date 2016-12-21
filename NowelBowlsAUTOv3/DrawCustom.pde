ArrayList<Movement>moves = new ArrayList<Movement>();
boolean saveMoves = false;
boolean firstmove = true;
int currentMove = 0;
int cursorX = 0;
int cursorY = 0;
ArrayList<PVector>coords = new ArrayList<PVector>();
PVector startMouse = new PVector();
PVector endMouse = new PVector();

float gridX = 1;
float gridY = 1;

boolean gogogo = false;

interface Movement  {
  void move();
  float getX();
  float getY();
}
class Move implements Movement {
  float x;
  float y;
  boolean draw = false;
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  Move(float _x, float _y, boolean _draw) {
    x = _x;
    y = _y;
    draw = _draw;
    if (x<0) {
      x = 0;
    }
    if (x>width) {
      x = width;
    }
    if (y<0) {
      y = 0;
    }
    if (y>height) {
      y = height;
    }
  }
  void move() {
    if (draw) {
      lowerBrush();
    } else {
      raiseBrush();
    }
    //MoveCustom(x, y);
    //MoveRelativeXY(y, x) ;
    int fx = floor(map(x, 0, width/2, 0, 1600));  // 0 1600
    int fy = floor(map(y, 0, height, 0, 500));
    println("ONE MOVE !!!! "+fx+" "+fy);
    MoveToXY(fy, fx); // invert because of eggbot ^^
  }
}





void drawMoves() {
  //println("isLocked: "+isLocked+"  "+moves.size());
  if (!isLocked && moves.size() > 0 && gogogo) {
    Lock();
    println(moves.get(0));
    Movement tempMove = moves.get(0);
    moves.remove(0);
    tempMove.move();
  }
}
void betweenClick() {
  if (saveMoves) {
    background(0);
    noFill();
    stroke(255, 0, 0);
    if (firstmove) {
      firstmove = false;
      oldMouse.x = snap.x;
      oldMouse.y = snap.y;
      //coords.add(new PVector(snapX-oldMouseX, snapY-oldMouseY));
    }  else {
      PVector prevToVel = new PVector();
      if (coords.size()>1) {
        prevToVel = coords.get(coords.size()-2);
      }
      //PVector mouse = new PVector(snap.x, snap.y);
      //PVector oldMouse = new PVector(oldMouse.x, oldMouse.y);
      PVector diff = PVector.sub(oldMouse, prevToVel).mult(0.01);
      float dst = PVector.dist(oldMouse, snap);
      //point(mouse.x+diff.x, mouse.y+diff.y);
      //println("dst: "+diff);
      //ellipse(oldMouseX+diff.x, oldMouseY+diff.y, 10, 10);
      if (dst>1) {
        coords.add(new PVector(snap.x-oldMouse.x, snap.y-oldMouse.y));
        oldMouse.x = snap.x;
        oldMouse.y = snap.y;
      }
    }
    //endMouse = new PVector(snapX, snapY);

    ellipse(mouseSmooth.x, mouseSmooth.y, 20, 20);
    beginShape();
    PVector lineDrawer = startMouse.get();
    for (int i=0; i<coords.size(); i++) {
      lineDrawer.add(coords.get(i));
      vertex(lineDrawer.x, lineDrawer.y);
    }
    endShape();
    //line(startMouse.x, startMouse.y, endMouse.x, endMouse.y);
  }
}
void mousePressed() {
  gogogo = false;
  mouseSmooth = new PVector(mouseX, mouseY);
  mouseVel = new PVector();
  calculSmooth();
  startMouse = new PVector(snap.x, snap.y);
  firstmove = true;
  saveMoves = true;
  coords = new ArrayList<PVector>();
  moves = new ArrayList<Movement>();
  currentMove = 0;
}
void mouseReleased() {
  saveMoves = false;
  //followPath();
  repeatPath();
  //moves.add(new Move(1, 1, false));
  //moves.add(new Move(width, height, true));
}