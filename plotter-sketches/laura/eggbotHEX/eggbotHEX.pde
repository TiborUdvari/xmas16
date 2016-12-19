import processing.svg.*;

//height="672.9198"
//width="4129.501"

  PGraphics pgDrawing;
PShape bg;

float unitSize = 60;
float eqTriH = 0.8660254;
int w = 3200;
int h = 800;
int cellsX = int(w/(unitSize*3));
int cellsY = int(h/(unitSize*eqTriH*2+eqTriH));

void setup(){
  //int f = 4;
  //size(4129, 672);
  size(3200, 800);

  //size(1600, 400);
  //size(800, 200);
  //size(1032, 168);
  smooth(4);
  
  pgDrawing = createGraphics(width, height, SVG, "test.svg");
  pgDrawing.beginDraw();
 /* pgDrawing.background(255);
  pgDrawing.stroke(0);
  pgDrawing.strokeWeight(1);
   pgDrawing.noFill();
  
  pgDrawing.rectMode(CENTER);
  pgDrawing.ellipseMode(CENTER);*/
  drawSVG();
  
  //pgDrawing.dispose();
  pgDrawing.endDraw();
  bg = loadShape("test.svg");
}

void drawSVG(){
  //pgDrawing.background(255);
  // 5
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {
      pgDrawing.beginShape();
      for (int k = 0; k < 6; k++) {
        //if(k!=3){
        pgDrawing.vertex(unitSize+i*unitSize*3+cos(TWO_PI/6*k)*unitSize, unitSize*eqTriH+j*unitSize*2*eqTriH+sin(TWO_PI/6*k)*unitSize);
        //}
      }
      pgDrawing.endShape(CLOSE);
     pgDrawing.beginShape();
      for (int k = 0; k < 6; k++) pgDrawing.vertex(unitSize*2.5+i*unitSize*3+cos(TWO_PI/6*k)*unitSize, unitSize*eqTriH*2+j*unitSize*2*eqTriH+sin(TWO_PI/6*k)*unitSize);
      pgDrawing.endShape(CLOSE);
    }
  }
}

void draw(){
  shape(bg, 0, 0);
  noLoop();
}