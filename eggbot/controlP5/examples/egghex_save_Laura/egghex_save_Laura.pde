import processing.svg.*;

PGraphics g;
PShape bg;

// ------ ControlP5 ------

import controlP5.*;
ControlP5 controlP5;
boolean GUI = false;
int guiEventFrame = 0;
Slider[] sliders;
Range[] ranges;
Toggle[] toggles;



// Pattern
float repeat = 1;
float distance = -10;
float[] Xrandom = new float[30];
float[] Yrandom = new float[30];
float[] radius = new float[30];


float HexSpacing = 0;
float HexSize = 20; 
int HexRepeat =3 ; 

boolean drawTriangles = true;
PShape custom;

void setup() {
  size(1200, 500);
  smooth(4);
  setupGUI();
  g = createGraphics(800, 200);
  custom = loadShape("v.svg");
  for (int i = 0; i<30; i++) {
    Xrandom[i]= random(0, g.width);
    Yrandom[i]= random(g.height/6, g.height*5/6);
    radius[i] = random(60);
  }
}

void draw() {
  render(g,1);
  image(g, 250, 100);
  }
  
  void render (PGraphics pgDrawing, float scale){
  pgDrawing.beginDraw();
  pgDrawing.background(255);
  pgDrawing.stroke(0);
  pgDrawing.strokeWeight(1);
  custom.disableStyle();
   pgDrawing.noFill();
   println(repeat);
   repeat = round(repeat);
   HexSpacing = round(HexSpacing);
   for (int i=0; i<repeat; i++) {
     for (int j = 0; j < HexSpacing; j++){
     
     pgDrawing.shape(custom, ((pgDrawing.width/(2))-(repeat*(40+distance))/2)+ (i*(40+distance)), ((pgDrawing.height/(2))-(HexSpacing*(40+distance))/2) + j*(40+distance), 40, 40);
     }
     
   }
  



  //// --- Ellipse random
  //for (int i=0; i<10; i++) {
  //  pgDrawing.ellipse(Xrandom[i], Yrandom[i], radius[i], radius[i]);
  //}
  //pgDrawing.fill(255);
  //pgDrawing.noStroke();


  ////----- Square + lines to go Above the Ellipse
  //pgDrawing.rect(0, 0, pgDrawing.width, pgDrawing.height/6);
  //pgDrawing.rect(0, pgDrawing.height*5/6, pgDrawing.width, pgDrawing.height*5/6);
  //pgDrawing.stroke(0);
  //pgDrawing.line(0, pgDrawing.height/6, pgDrawing.width, pgDrawing.height/6);
  //pgDrawing.line(0, pgDrawing.height/6+5, pgDrawing.width, pgDrawing.height/6+5);

  //// --- Hex




  for (int level=1; level<4; level++) {
    float up = 1;
    if (level ==1 ) {
      up=1;
    } else if (level == 2) {
      up = 0;
    } else if (level == 3) {
      up = -0.333;
    }
    //for (int Hexlayer =1; Hexlayer <= HexRepeat; HexRepeat ++) {
    //}
    //for (int i=0; i<50; i++) {
    //  pgDrawing.pushMatrix();
    //  polygon(pgDrawing, 60*i+level*30, pgDrawing.height/2+up*level*HexSpacing, HexSize, 6);  // Heptagon
    //  pgDrawing.popMatrix();
    //}

    //--Inner Hex
    //for (int i=0; i<50; i++) {
    //  pgDrawing.pushMatrix();
    //  polygon(pgDrawing, 60*i+level*30, pgDrawing.height/2+up*level*HexSpacing, 10, 6);  // Heptagon
    //  pgDrawing.popMatrix();
    //}
  }

  //------ Triangles
  //for (int i=0; i<pgDrawing.width/40*repeat; i++) {
  //  pgDrawing.noFill();
  //  pgDrawing.triangle(40*i/repeat+mouseY, pgDrawing.height/6, 20 + 40*i/repeat, 0, 40 + 40*i/repeat, pgDrawing.height/6);
  //  pgDrawing.triangle(40*i/repeat+mouseY, pgDrawing.height*5/6, 20 + 40*i/repeat, pgDrawing.height, 40 + 40*i/repeat, pgDrawing.height*5/6);
  //}
  //pgDrawing.stroke(0);



  //pgDrawing.line(0, pgDrawing.height*5/6, pgDrawing.width, pgDrawing.height*5/6);
  //pgDrawing.line(0, pgDrawing.height*5/6-5, pgDrawing.width, pgDrawing.height*5/6-5);

  pgDrawing.dispose();
  pgDrawing.endDraw();
  
}


void polygon(PGraphics pgDrawing, float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  pgDrawing.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    pgDrawing.vertex(sx, sy);
  }
  pgDrawing.endShape(CLOSE);
}

//SAVE
void keyPressed() {
  if (key == 's') {

    PGraphics offs = createGraphics(width, height, SVG, "test.svg");
    //float s=(float) offs.width/width;
    render(offs, 1);

//-    offs.save(System.currentTimeMillis() + ".png");
    println("saved");
   // bg = loadShape("test.svg");
  }
}