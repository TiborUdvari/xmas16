// 2016.12.18
// Tibor Udvari
// 10.3cm x 14.8cm => Aspect ratio 1.4368

import rita.*;
import geomerative.*;
import processing.svg.*;
import java.util.Date;

PGraphics pg;
PShape bg;
RShape grp;

int w = 800;
float aspectRatio = 14.8 / 10.3;

RiMarkov rm;
String fileName;

String[] sentences;
String allText;
String fontName = "FreeSans.ttf";

GeomText[] items;

void setup(){
  //size(800, 1149);
  size(400, 575);
  smooth(4);
  
  RG.init(this);
  
  rm = new RiMarkov(3);
  rm.loadFrom("mid+xmas.txt", this);
  
  generateText();
  createPGraphics();
}

void generateText(){
  sentences = rm.generateSentences(2);
  allText = "";
  
  String currentText = "";
  for (String sentence: sentences){
    allText = allText + sentence + "\n";
    
    
  }
  
  RG.setPolygonizer(RG.ADAPTATIVE);
  
  int maxLetters = 40;
  // add to new things until overflow
  
  for (int i = 0; i < allText.length(); i++){
    
  }
  
  items = new GeomText[sentences.length];
  for (int i=0; i<sentences.length; i++) {
    int s = width / 25;
    float offset=i*s;
    items[i]= new GeomText(sentences[i], s, 0, -3*s+offset);
  }
  
}

void createPGraphics(){
  fileName = svgFileName();
  
  pg = createGraphics(width, height, SVG, fileName);
  pg.beginDraw();
  
  pg.stroke(0);
  pg.strokeWeight(1);
  pg.background(255);

  drawSVG();
  
  pg.dispose();
  pg.endDraw();
  bg = loadShape(fileName);
}

void drawSVG(){
  //pg.translate(width/2, height/2);
  
  // 40 
  for (int i=0; i<items.length; i++) {
    items[i].display(pg);
  }
}

void draw(){
  shape(bg, 0, 0);
  noLoop();
}

String svgFileName(){
  return new Date().getTime() + ".svg";
}

void mouseClicked(){
  generateText();
  createPGraphics();
  
  for (int i=0; i<items.length; i++) {
    items[i].display(pg);
  }
  
  redraw();
  
  print(allText);
}

/*
Simple wrapper for an individual Geromerative group.
*/


class GeomText{
  String msg;
  RShape grp;
  RPoint[] points; 
  int fontSize;
  float posx;
  float posy;
  
  GeomText(String MSG, int FONTSIZE, float POSX, float POSY){
    msg=MSG;
    fontSize= FONTSIZE;
    posx= POSX;
    posy= POSY;
    
    create();
    
  }
 
  void create(){
    grp= RG.getText(msg, fontName, fontSize, CENTER);
    points= grp.getPoints();
  }
    
  void display(PGraphics pg){
    pg.pushMatrix();
    pg.translate(width/2, height/2);
    pg.translate(posx, posy);
    pg.stroke(130, 180);
    grp.draw(pg);
    pg.popMatrix();
  }
}