import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.math.noise.*;
import toxi.processing.*;

ToxiclibsSupport gfx;
Voronoi voronoi;
import geomerative.*;
import processing.svg.*;

PGraphics frame;
PShape bg;

// Declare the objects we are going to use, so that they are accesible from setup() and from draw()
RFont f;
RShape grp;
RPoint[] points;

void setup()
{
  size(800, 300);

  RG.init(this);
  //  Load the font file we want to use (the file must be in the data folder in the sketch floder), with the size 60 and the alignment CENTER
  //grp = RG.getText("YUKI", "FreeSans.ttf", 72, CENTER);
  grp = RG.getText("XMAS", "FreeSans.ttf", 250, CENTER);

  gfx = new ToxiclibsSupport( this );
  voronoi = new Voronoi();  
  for ( int i = 0; i < 50; i++ ) {
    voronoi.addPoint( new Vec2D( random(width)*sin(width), random(height) ) );
  }
} 

void draw() {
  render(frame);
}

void render(PGraphics frame)
{
  RG.setPolygonizer(RG.ADAPTATIVE);
  grp.draw();

  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(map(18, 0, 300, 3, 200));
  points = grp.getPoints();

  if (points != null) {
    int count = 0;
    for ( int i = 0; i<points.length; i++ ) {
      voronoi.addPoint( new Vec2D( points[i].x+width/2, points[i].y + height -10) );

      if (count == 0) {
        int county=0;
        for (int y = 0; y< 5; y++) {
          //voronoi.addPoint( new Vec2D( points[i].x+width/2+random(1, 5), points[i].y + (height -10) + random(1, 5)) );
          voronoi.addPoint( new Vec2D( (points[i].x + width/2), points[i].y + (height -10) + county*2) );
          county++;
        }
      }
    }
    count++;
  }

  for ( Polygon2D polygon : voronoi.getRegions () ) {
    gfx.polygon2D( polygon );
  }
}


void keyPressed() {
  if (key == 's') {
    PGraphics offs = createGraphics(width, height, SVG, "test.svg");
    gfx.setGraphics(offs);
    offs.beginDraw();
    render(offs);
    offs.dispose();
    offs.endDraw();
    println("saved");
  }
}