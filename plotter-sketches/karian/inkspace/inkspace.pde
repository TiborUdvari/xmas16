// INKSPACE
// Karian Før

//

// font size
int ts = 90;

// number of lines to jump
int offsetY = 7;

// maximum offset of the points
int offsetL = 5;

// blurring level
int blurring = 50;

//

import controlP5.*;
ControlP5 cp5;
Textfield tf;
String ti;
float tw;
float th;
boolean computing = false;

//

PFont font;
PGraphics raster;
PShader blur;
int passes = 0;

//


import peasy.*;
PeasyCam cam;

//

import processing.svg.*;
PGraphics pg;
PShape ps;

//

void setup()
{
  size(1024, 768, P3D);
  smooth(4);
  background(0);

  //

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.setColorForeground(color(255));
  cp5.setColorBackground(color(0));
  cp5.setColorActive(color(255));

  tf = cp5.addTextfield("textinput").setPosition(15, 15).setSize(200, 20).setFocus(true);
  tf.setAutoClear(false).keepFocus(true);
  tf.setLabel("INKSPACE");

  //

  font = createFont("ORTE2LTT.TTF", ts);
  // font = createFont("GothamRnd-Light.otf", ts);
  textFont(font);

  raster = createGraphics(800, 300, P2D);
  raster.beginDraw();
  raster.clear();
  raster.endDraw();

  blur = loadShader("blur.glsl"); // taken from processing examples

  //

  cam = new PeasyCam(this, 0, 0, 0, 100);
  cam.setPitchRotationMode();
}

public void textinput(String input)
{
  if (!computing) {

    // update text values
    ti = input;
    tw = textWidth(ti) + 30;
    th = ts + 30;

    // clear stuff
    tf.clear();
    raster.beginDraw();
    raster.clear();
    raster.endDraw();

    computing = true;
    println("Text input: " + ti);

  } else {
    println("In progress");
  }
}

void draw()
{
  if (computing) {

    // blurring the text with shader & multiple pass
    if (passes <= blurring) {
      raster.beginDraw();
      raster.textFont(font);
      raster.textAlign(CENTER, CENTER);
      raster.fill(255);
      raster.filter(blur);
      raster.text(ti, raster.width/2, raster.height/2);
      raster.endDraw();

      println("Computing: " + passes + " / " + blurring);
      passes++;

    //
    } else {
      computing = false;
      passes = 0;
      println("Done");
    }
  }

  //

  background(0);
  stroke(255);
  strokeWeight(2);
  // noFill();
  fill(0);

  pushMatrix();
  translate(-raster.width/2, -raster.height/2);

  sampleRaster(this.g);

  popMatrix();

  //

  cam.beginHUD();
  cp5.draw();
  stroke(255);
  strokeWeight(1);
  fill(0);
  rect(width-raster.width*0.5-15, height-raster.height*0.5-15, raster.width*0.5, raster.height*0.5);
  image(raster, width-raster.width*0.5-15, height-raster.height*0.5-15, raster.width*0.5, raster.height*0.5);
  if (ps != null) {
    rect(15, height-raster.height*0.5-15, raster.width*0.5, raster.height*0.5);
    shapeMode(CORNER);
    shape(ps, 15, height-raster.height*0.5-15, raster.width*0.5, raster.height*0.5);
  }
  cam.endHUD();
}

void keyPressed()
{
  if (computing) return;

  if (key == ' ') {
    pg = createGraphics(raster.width, raster.height, SVG, "inkspace.svg");

    pg.beginDraw();
    pg.stroke(255);
    pg.strokeWeight(1);
    pg.noFill();

    // we draw a rect to make the svg same size as the raster
    //pg.rect(0, 0, raster.width, raster.height);

    sampleRaster(pg);
    
    pg.dispose();
    pg.endDraw();

    ps = loadShape("inkspace.svg");
  }
}

void sampleRaster(PGraphics p)
{
  // startX and endX of the lines depending on the current text width
  float bl = raster.width/2 - tw/2;
  float el = raster.width/2 + tw/2;

  boolean winding = false;
  p.beginShape();

  raster.loadPixels();
  for (int y = 0; y < raster.height; y += offsetY) {

    // no need to render a line if 'y' is not on the font
    if (y < raster.height/2 - th/2 || y > raster.height/2 + th/2) continue;

    // first point of the line
    if (!winding) { p.vertex(bl, y); } else { p.vertex(el, y); }

    for (int x = 0; x < raster.width; x++) {
      int px = (!winding) ? x : raster.width-x;
      int i = y * raster.width + px;

      // luminance calculation, taken from http://stackoverflow.com/a/596243
      float b = 0.299 * red(raster.pixels[i]) + 0.587 * green(raster.pixels[i]) + 0.114 * blue(raster.pixels[i]);

      // 2D or 3D offset of the vertex depending on the luminance value
      if (b > 0.0) {
        p.vertex(px, y - map(b, 0, 255, 0, offsetL));
        // p.vertex(x, y, map(b, 0, 255, 0, offsetL));
      }
    }

    // end point of the line
    if (!winding) { p.vertex(el, y); } else { p.vertex(bl, y); }

    // change winding
    winding = !winding;
  }
  
  p.endShape();
}