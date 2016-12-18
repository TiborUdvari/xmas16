import geomerative.*;
import processing.svg.*;

PGraphics pg;
PShape bg;

RShape grp;

void setup(){  
  size(1032, 168);
  smooth(4);
  
  RG.init(this);
  grp = RG.getText("Hello world!", "FreeSans.ttf", 72, CENTER);

  pg = createGraphics(width, height, SVG, "test.svg");
  pg.beginDraw();
  pg.background(255);
  pg.stroke(0);
  pg.strokeWeight(1);
  
  drawSVG();
  
  pg.dispose();
  pg.endDraw();
  bg = loadShape("test.svg");
}

void drawSVG(){
  pg.background(255);
  pg.translate(width/2, height/2);
  
  grp.draw(pg);
}

void draw(){
  shape(bg, 0, 0);
  noLoop();
}