import geomerative.*;
import processing.svg.*;

RShape shp;
RPoint[] points;
RPoint[] tangents;

boolean ignoringStyles = true;

int numPoints = 500;
PGraphics pg;

void setup(){
  size(600, 600);
  smooth();

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles(ignoringStyles);
  
  shp = RG.loadShape("text.svg");
  shp = RG.centerIn(shp, g, 100);

  
}
void keyPressed()
{
  
  if (key == ' ') {
    pg = createGraphics(width, height, SVG, "inkspace.svg");

    pg.beginDraw();
    pg.stroke(255);
    pg.strokeWeight(1);
    pg.noFill();

    // we draw a rect to make the svg same size as the raster
    pg.rect(0, 0, width, height);

    sampleRaster(pg);

    pg.dispose();
    pg.endDraw();

    //ps = loadShape("inkspace.svg");
  }
}


void sampleRaster(PGraphics p)
{
  
  println(points.length);
  for(int i=0;i<points.length;i++){
    p.pushMatrix();
    p.translate(points[i].x, points[i].y);
    ellipse(0, 0, 10, 10);
    p.line(0, 0, tangents[i].x, tangents[i].y);
    p.popMatrix();  
  }
  
}

void draw(){
  translate(mouseX, mouseY);
  background(#2D4D83);
  
  RG.shape(shp);

  noFill();
  stroke(255, 100);
  
  points = null;
  tangents = null;
  
  for(int i=0; i<numPoints; i++){
    RPoint point = shp.getPoint(float(i)/float(numPoints));
    RPoint tangent = shp.getTangent(float(i)/float(numPoints));
    if(points == null){
      points = new RPoint[1];
      tangents = new RPoint[1];
      
      points[0] = point;
      tangents[0] = tangent;
    }else{
      points = (RPoint[])append(points, point);
      tangents = (RPoint[])append(tangents, tangent);
    }
  }
  
  for(int i=0;i<points.length;i++){
    pushMatrix();
    translate(points[i].x, points[i].y);
    ellipse(0, 0, 10, 10);
    line(0, 0, tangents[i].x, tangents[i].y);
    popMatrix();  
  }
  
}

void mousePressed(){
  ignoringStyles = !ignoringStyles;
  RG.ignoreStyles(ignoringStyles);
}