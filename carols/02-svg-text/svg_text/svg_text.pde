import processing.svg.*;

//height="672.9198"
//width="4129.501"
PGraphics pgDrawing;
PShape bg;

void setup(){  
  size(1032, 168);
  smooth(4);
  
  pgDrawing = createGraphics(width, height, SVG, "test.svg");
  pgDrawing.beginDraw();
  pgDrawing.background(255);
  pgDrawing.stroke(0);
  pgDrawing.strokeWeight(1);
  
  drawSVG();
  
  pgDrawing.dispose();
  pgDrawing.endDraw();
  bg = loadShape("test.svg");
}

void drawSVG(){
  pgDrawing.background(255);
  
  pgDrawing.textSize(32);
  pgDrawing.text("word", 10, 30); 
  pgDrawing.fill(0, 102, 153);
  
  /*
  // 5
  int h = 5;
  int d = height / (h + 1);
  int w = width / d;
  int s = height / 10;
  
  for (int i = 1; i < h + 1; i++) {
    for (int j = 1; j < w; j++) {
      float r = random(0, 4);
      if (r < 1){
        pgDrawing.ellipse(j * d, i * d, s, s);
      } else if (r < 2) {
        pgDrawing.rect(j * d, i * d, s, s);
      }  
    }
  }*/
}

void draw(){
  shape(bg, 0, 0);
  noLoop();
}