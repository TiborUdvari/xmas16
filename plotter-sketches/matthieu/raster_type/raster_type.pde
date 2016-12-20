int w, h;
float radius;
float angleOld, angleNew;
boolean ready;
PImage img;
PGraphics g1, g2;

PFont euclid;

import processing.svg.*;
PGraphics pg;

ArrayList<Float> coordinatesX;
ArrayList<Float> coordinatesY;

int lineCounter = 0;
int lineNbr = 250;

void setup() {
  img = loadImage("hello.png");
  size(800, 800);
  initialize();

  euclid = createFont("EuclidFlexEcal-Bold.otf", 32);
  textFont(euclid);
  
  
  w = img.width;
  h = img.height;
  ready = false;
  g1 = createGraphics(w, h);
  g1.beginDraw();
  g1.background(0);
  g1.stroke(255);
  g1.strokeWeight(0.1);
  g2 = createGraphics(w, h);
  g2.beginDraw();
  g2.background(255);
  g2.fill(0);
  g2.textFont(euclid);
  g2.textSize(500);
  g2.textAlign(CENTER, CENTER);
  g2.text("N", width/2, height/2);
  //g2.image(img, 0, 0);
  g2.stroke(255, 0, 0);
  //g2.strokeWeight(0.2);
}

void initialize() {

  background(0);
  lineCounter = 0;
  coordinatesX = new ArrayList<Float>();
  coordinatesY = new ArrayList<Float>();


  radius = min(w, h)/2;
  angleNew = random(2*PI);
}

void draw() {

  if (img.height>0 && ready==false) {
    initialize();
    ready = true;
  }

  if (lineCounter < lineNbr) {
    lineCounter++;
    //  println(lineCounter);
    angleOld = angleNew;
    float min, b, angle;

    int n = 80;

    if (lineCounter < 50) {
      n = 1;
    }

    min = 255;

    for (int i=0; i<n; i++) {
      angle = random(2*PI);
      b = chordBrightness(angleOld, angle);
      //  println(b);
      if (b<min) {
        min = b;
        angleNew = angle;
      }
    }
    g1.beginDraw();
    g2.beginDraw();
    drawChord(angleOld, angleNew);
    g1.endDraw();
    g2.endDraw();
    image(g1, 0, 0);
  }
  if (mousePressed) {
    image(g2, 0, 0);
  }

}

void drawChord(float a1, float a2) {
  float x1, y1, x2, y2;
  x1 = radius*sin(a1)+w/2;
  y1 = radius*cos(a1)+h/2;
  x2 = radius*sin(a2)+w/2;
  y2 = radius*cos(a2)+h/2;



  g1.line(x1, y1, x2, y2);
  g2.line(x1, y1, x2, y2);

  /*
  pg.beginDraw();
   pg.beginShape();
   pg.vertex(x1,x2);
   pg.vertex(x2,y2);
   pg.endShape();
   pg.endDraw();
   */
  coordinatesX.add(x1);
  coordinatesX.add(x2);
  coordinatesY.add(y1);
  coordinatesY.add(y2);
}

float chordBrightness(float a1, float a2) {
  float x1, y1, x2, y2, x, y;
  x1 = radius*sin(a1)+w/2;
  y1 = radius*cos(a1)+h/2;
  x2 = radius*sin(a2)+w/2;
  y2 = radius*cos(a2)+h/2;
  int nSteps = 50;
  float sum = 0;
  for (int i=0; i<nSteps; i++) {
    x = x1 + (float)i/nSteps*(x2-x1);
    y = y1 + (float)i/nSteps*(y2-y1);
    sum += red(g2.get((int)x, (int)y))/(float)nSteps;
  }
  return sum;
}

void keyPressed() {



  if (key == ' ') {
    pg = createGraphics(width, height, SVG, "test.svg");

    pg.beginDraw();
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.noFill();

    // we draw a rect to make the svg same size as the raster
    // pg.rect(0, 0, width, height);
    pg.beginShape();
    for (int i = 0; i < coordinatesX.size(); i+=2) {
      pg.vertex(coordinatesX.get(i), coordinatesY.get(i));
      // pg.vertex(coordinatesX.get(i+1), coordinatesY.get(i+1));
    }
    pg.endShape();
    pg.dispose();
    pg.endDraw();
  } else {
    println(key);
    g1.clear();
    g2.clear();
    g2.beginDraw();
    g2.background(255);
    g2.fill(0);
    g2.textSize(500);
    g2.textAlign(CENTER, CENTER);
    g2.text(key, width/2, height/2);

    initialize();
  }
}