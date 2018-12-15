import processing.svg.*;

int stepX = 15;
int stepY = 15;
boolean[][] rot;
int qttX;
int qttY;
PGraphics pg;
PImage toDraw;
PFont pf;
boolean save = false;

void setup() {
  size(960, 440);
  qttX = floor(width/stepX);
  qttY = floor(height/stepY);
  println(qttX);
  println(qttY);
  rot = new boolean[qttY][qttX];
  toDraw = loadImage("sapin1.png");
  pf = loadFont("Renens1-Bold-48.vlw");
  //toDraw = loadImage("flocon1.png");
  //toDraw = loadImage("sapin2.png");
  pg = createGraphics(qttX, qttY);
  pg.beginDraw();
  pg.background(255);
  pg.noStroke();
  pg.fill(0);
  pg.textFont(pf, 15);
  pg.textMode(CENTER);
  pg.textAlign(CENTER);
  pg.imageMode(CENTER);
  pg.translate(pg.width/2, pg.height/2);
  //pg.rotate(-PI/4);
  //pg.image(toDraw, 0, 0, pg.width, pg.height);
  pg.textLeading(15);
  pg.text("JOYEUX\nNOWEL", 0, -2);
  pg.endDraw();
}
void draw() {

  //background(255);
  noFill();
  strokeWeight(1);
  stroke(0);
  for (int y = 0; y<qttY; y++) {
    for (int x = 0; x<qttX; x++) {
      color c = pg.get(x, y);
      if (brightness(c) > 127) {
        rot[y][x] = true;
      }  else {
        rot[y][x] = false;
      }
      //drawRect(x, y);
    }
  }
  stroke(255, 0, 0);
  if (save == true) {
    beginRecord(SVG, "joyeuxNowel15.svg");
  }
  for (int bx = qttX-1; bx>0; bx--) {
    tryLine(bx, 0, true);
  }
  for (int by = 0; by<qttY; by++) {
    tryLine(0, by, true);
    tryLine(0, by, false);
  }
  for (int bx = 0; bx<qttX; bx++) {
    tryLine(bx, qttY-1, false);
  }
  // gauche haut->bas
  /*x = 0;
   for (y = 0; y<qttY; y++) {
   }
   // bas gauche->droite
   y = qttY-1;
   for (x = 0; x<qttX; x++) {
   }*/
  if (save == true) {
    save = false;
    endRecord();
  }
}
void tryLine(int bx, int by, boolean invert) {
  int x = bx;
  int y = by;
  boolean isLine = false;
  while (x<qttX && y<qttY) {
    color c = pg.get(x, y);
    //
    float brF = brightness(c);
    //
    if (brF>127 == invert && !isLine) {
      isLine = true;
      beginShape();
      if(invert) {
      vertex(x*stepX, y*stepY);
      } else {
      vertex(x*stepX, y*stepY+stepY);
      }
      //println("StartLine "+x+" "+y);
    } else if (brF<=127 == invert && isLine) {
      isLine = false;
      if(invert) {
      vertex(x*stepX, y*stepY);
      } else {
      vertex(x*stepX, y*stepY+stepY);
      }
      endShape();
      //println("EndLine"+bx);
    }
    if (isLine && (x == qttX-1 || y == qttY-1)) {
      if(invert) {
      vertex(x*stepX+stepX, y*stepY+stepY);
      } else {
      vertex(x*stepX, y*stepY);
      }
      endShape();
      //println("EndLine MEGA END"+bx);
    }
    if(invert) {
      x++;
      y++;
    } else {
      x++;
      y--;
    }
  }
}
void mousePressed() {
  int getX = floor(mouseX/stepX);
  int getY = floor(mouseY/stepY);
  println(getX, getY);
  rot[getY][getX] = !rot[getY][getX];
}
void keyPressed() {
  if (key == ' ') {
    save = true;
  }
}