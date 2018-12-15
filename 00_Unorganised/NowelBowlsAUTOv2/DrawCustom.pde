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
    int fx = floor(map(x, 0, width, 0, 1600));  // 0 1600
    int fy = floor(map(y, 0, height, 0, 430));
    println("ONE MOVE !!!! "+fx+" "+fy);
    MoveToXY(fy, fx); // invert because of eggbot ^^
  }
}



void followPath() {
  background(0);
  stroke(255, 0, 0);
  noFill();
  beginShape();
  //for (int i=0; i<4000; i++) {
  boolean isWhile = true;
  int cntX = 0;
  while(isWhile) {
    Movement tempMove = new Move(0, 0, false);
    PVector newPos = new PVector();
    if (moves.size()>0) {
      tempMove = moves.get(moves.size()-1);
    }
    /*int previous = currentMove-1;
     if(previous<0) {
     previous=coords.size()-1;
     }*/
    //PVector previousCoord = coords.get(previous);
    newPos.x = tempMove.getX()+coords.get(currentMove).x; // temp move removed
    newPos.y = tempMove.getY()+coords.get(currentMove).y;
    //
    boolean willDraw = true;
    if (newPos.x < 0) {
      newPos.x += width;
      willDraw = false;
      cntX ++;
    }
    if (newPos.x > width) {
      newPos.x -=width;
      willDraw = false;
      cntX ++;
    }
    if (newPos.y < 0) {
      newPos.y += height;
      willDraw = false;
    } 
    if (newPos.y > height) {
      newPos.y -= height;
      willDraw = false;
    }
    if(cntX > 10) {
      isWhile = false;
    }
    //
    if (!willDraw) {
      //moves.add(new BrushState(false, 0, 0));
      endShape();
      beginShape();
    }
    vertex(newPos.x, newPos.y);

      moves.add(new Move(floor(newPos.x), floor(newPos.y), willDraw));
    
    if (!willDraw) {
      // moves.add(new BrushState(true, 0, 0));
    }
    //int encodedPos = xyEncodeInt2(floor(newPos.x), floor(newPos.y));
    //ToDoList = append(ToDoList, encodedPos);
    currentMove++;
    if (currentMove>=coords.size()) {
      currentMove = 0;
    }
  }
  endShape();
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
      if(coords.size()>1) {
        prevToVel = coords.get(coords.size()-2);
      }
      //PVector mouse = new PVector(snap.x, snap.y);
      //PVector oldMouse = new PVector(oldMouse.x, oldMouse.y);
      PVector diff = PVector.sub(oldMouse, prevToVel).mult(0.01);
      float dst = PVector.dist(oldMouse, snap);
      //point(mouse.x+diff.x, mouse.y+diff.y);
      //println("dst: "+diff);
      //ellipse(oldMouseX+diff.x, oldMouseY+diff.y, 10, 10);
      if (dst>5) {
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
      followPath();
      //moves.add(new Move(1, 1, false));
      //moves.add(new Move(width, height, true));
}