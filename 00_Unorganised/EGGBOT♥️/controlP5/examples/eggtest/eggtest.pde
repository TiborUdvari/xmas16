import processing.svg.*;

PGraphics pgDrawing;


// ------ ControlP5 ------

import controlP5.*;
ControlP5 controlP5;
boolean GUI = false;
int guiEventFrame = 0;
Slider[] sliders;
Range[] ranges;
Toggle[] toggles;



// Pattern
float repeat=1;
float[] Xrandom = new float[30];
float[] Yrandom = new float[30];
float[] radius = new float[30];


boolean drawTriangles = true;


void setup() {
  size(1200, 500);
  smooth(4);
  setupGUI();
  pgDrawing = createGraphics(800, 200);
  for (int i = 0; i<30; i++) {
    Xrandom[i]= random(0, pgDrawing.width);
    Yrandom[i]= random(pgDrawing.height/6, pgDrawing.height*5/6);
    radius[i] = random(60);
  }
}

void draw() {
  print();
  pgDrawing.beginDraw();
  pgDrawing.background(255);
  pgDrawing.stroke(0);
  pgDrawing.strokeWeight(1);




  // --- Ellipse random
  for (int i=0; i<10; i++) {
    pgDrawing.ellipse(Xrandom[i], Yrandom[i], radius[i], radius[i]);
  }
  pgDrawing.fill(255);
  pgDrawing.noStroke();







  //----- Square + lines to go Above the Ellipse
  pgDrawing.rect(0, 0, pgDrawing.width, pgDrawing.height/6);
  pgDrawing.rect(0, pgDrawing.height*5/6, pgDrawing.width, pgDrawing.height*5/6);
  pgDrawing.stroke(0);
  pgDrawing.line(0, pgDrawing.height/6, pgDrawing.width, pgDrawing.height/6);
  pgDrawing.line(0, pgDrawing.height/6+5, pgDrawing.width, pgDrawing.height/6+5);

  // --- Hex
  for (int i=0; i<50; i++){
  pgDrawing.pushMatrix();
  polygon(60*i, pgDrawing.height/2, 20, 6);  // Heptagon
  pgDrawing.popMatrix();

  }
  

  //------ Triangles
  for (int i=0; i<pgDrawing.width/40*repeat; i++) {
    pgDrawing.noFill();
    pgDrawing.triangle(40*i/repeat+mouseY, pgDrawing.height/6, 20 + 40*i/repeat, 0, 40 + 40*i/repeat, pgDrawing.height/6);
    pgDrawing.triangle(40*i/repeat+mouseY, pgDrawing.height*5/6, 20 + 40*i/repeat, pgDrawing.height, 40 + 40*i/repeat, pgDrawing.height*5/6);
  }
  pgDrawing.stroke(0);



  pgDrawing.line(0, pgDrawing.height*5/6, pgDrawing.width, pgDrawing.height*5/6);
  pgDrawing.line(0, pgDrawing.height*5/6-5, pgDrawing.width, pgDrawing.height*5/6-5);

  pgDrawing.dispose();
  pgDrawing.endDraw();
  image(pgDrawing, 250, 100);
}


void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  pgDrawing.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    pgDrawing.vertex(sx, sy);
  }
  pgDrawing.endShape(CLOSE);
}