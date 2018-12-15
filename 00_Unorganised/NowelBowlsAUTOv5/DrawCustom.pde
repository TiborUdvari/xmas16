ArrayList<Movement>moves = new ArrayList<Movement>();
boolean saveMoves = false;
boolean firstmove = true;
int currentMove = 0;
int cursorX = 0;
int cursorY = 0;
ArrayList<PVector>coords = new ArrayList<PVector>();
PVector startMouse = new PVector();
PVector endMouse = new PVector();
int[] lineCoords;
boolean modifyLine = false;

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
    if (x>offScreen.width) {
      x = offScreen.width;
    }
    if (y<0) {
      y = 0;
    }
    if (y> offScreen.height) {
      y = offScreen.height;
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
    int fx = floor(map(x, 0, offScreen.width/2, 0, 1600));  // 0 1600
    int fy = floor(map(y, 0, offScreen.height, 0, 550));
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
    if (mode == 0) {
      //background(0);
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
    } else if (mode == 1) {
      if (mouseX < 400) {
        //for(int i = -pic; i<=pic; i++) {
        int f = floor(mouseY/10);
        if (f>=0 && f<lineCoords.length) {
          //float perc = abs(i)/float(pic/2);
          //lineCoords[f] += round((mouseX*perc-lineCoords[f])/100f);
          lineCoords[f] = mouseX;
        }
        //}
      }
    }
  }
}
int pic = 100;
int mode = 0;
int modeQtt = 4;
void mousePressed() {
  if (mode == 0) {
    mouseSmooth = new PVector(0, 0);
    mouseVel = new PVector();
    calculSmooth();
    startMouse = new PVector(snap.x, snap.y);
    firstmove = true;
    saveMoves = true;
    coords = new ArrayList<PVector>();
    moves = new ArrayList<Movement>();
    currentMove = 0;
  } else if (mode == 1) {
    coords = new ArrayList<PVector>();
    moves = new ArrayList<Movement>();
    saveMoves = true;
  }
}
void mouseReleased() {
  if (mode == 0) {
    saveMoves = false;
    repeatPath(0);
    //moves.add(new Move(1, 1, false));
    //moves.add(new Move(width, height, true));
  } else if (mode == 1) {
    saveMoves = false;
    //
    coords.add(new PVector(0, 0));
    //
    for (int i=1; i<lineCoords.length; i++) {
      int diff = lineCoords[i]-lineCoords[i-1];
      coords.add(new PVector(diff, 10));
    }
    repeatPath(10);
  }
}
void drawLines() {
  stroke(255, 0, 255);
  beginShape();
  for (int i=0; i<lineCoords.length; i++) {
    vertex(lineCoords[i], i*10);
  }
  endShape();
}