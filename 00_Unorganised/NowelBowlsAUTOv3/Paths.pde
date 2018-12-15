// ----- repeat (one line)

void repeatPath() {
  stroke(255);
  //println(coords.get(0).x+"  "+coords.get(coords.size()-1).x);
  PVector lastPoint = new PVector(0, 0);
  int decalage = floor(random(coords.size()));
  //
  float firstDown = -1;
  for(int i=0; i<coords.size(); i++) {
    lastPoint.x += coords.get(i).x;
    lastPoint.y += coords.get(i).y;
  }
  if (coords.get(0).x < lastPoint.x && coords.get(0).y < lastPoint.y) {
    currentMove = 0;
    boolean more = true;
    int dir = 1;
    int qtt = 0;
    //
    beginShape();
    //
    while (qtt<24) {
      Movement tempMove = new Move(0, 0, false);
      PVector newPos = new PVector();
      if (moves.size()>0) {
        tempMove = moves.get(moves.size()-1);
      }
      newPos.x = tempMove.getX()+coords.get(currentMove).x*dir; // temp move removed
      newPos.y = tempMove.getY()+coords.get(currentMove).y*dir;
      // 
      if (newPos.y < 0) {
        if (newPos.x > width/2) {
          more = false;
        }
      }
      if (newPos.y > height) {
        if (newPos.x < 0) {
          more = false;
        }
      }
      //
      float largeurRestante = width/2-newPos.x;
      float qttRestante = 24-qtt;
      float distanceAdaptive = largeurRestante/qttRestante;
      //
      println(distanceAdaptive);
      //
      if (newPos.y < 0) {
        dir = 1;
        newPos.y = 0;
        newPos.x += distanceAdaptive;
        qtt++;
        //currentMove+=decalage;
      } 
      if (newPos.y >= height) {
        dir = -1;
        newPos.y = height-1;
        newPos.x += 50;
        qtt++;
        //currentMove-=decalage;
      }
      //
      vertex(newPos.x, newPos.y);
      moves.add(new Move(newPos.x, newPos.y, true));
      //
      currentMove+=dir;
      //
      //
      if (currentMove>=coords.size()) {
        currentMove-=coords.size();
      }
      if (currentMove<0) {
        currentMove += coords.size();
      }
      //println("####"+currentMove+"  "+dir);
    }
    //
    endShape();
    //
  }
}

// ----- follow

void followPath() {
  background(0);
  stroke(255, 0, 0);
  noFill();
  beginShape();
  //for (int i=0; i<4000; i++) {
  boolean isWhile = true;
  int cntX = 0;
  while (isWhile) {
    Movement tempMove = new Move(0, 0, false);
    PVector newPos = new PVector();
    if (moves.size()>0) {
      tempMove = moves.get(moves.size()-1);
    }

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
    if (cntX > 10) {
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