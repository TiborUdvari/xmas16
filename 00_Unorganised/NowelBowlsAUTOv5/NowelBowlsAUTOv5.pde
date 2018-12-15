import de.looksgood.ani.*;
import processing.serial.*;

import javax.swing.UIManager; 
import javax.swing.JFileChooser; 

PVector oldMouse = new PVector();

int cx = 0;
int cy = 0;
// User Settings: 
float MotorSpeed = 100.0;  // Steps per second, 1500 default

int ServoUpPct = 80;    // Brush UP position, %  (higher number lifts higher). 
int ServoPaintPct = 70;    // Brush DOWN position, %  (higher number lifts higher). 
int ServoWashPct = 20;    // Brush DOWN position for washing brush, %  (higher number lifts higher). 

boolean reverseMotorX = false;
boolean reverseMotorY = false;

int delayAfterRaisingBrush = 300; //ms
int delayAfterLoweringBrush = 300; //ms

int ColorFadeDist = 1000;     // How slowly paint "fades" when drawing (higher number->Slower fading)
int ColorFadeStart = 250;     // How far you can paint before paint "fades" when drawing 

int minDist = 4; // Minimum drag distance to record

//boolean debugMode = true;
boolean debugMode = false;


// Offscreen buffer images for holding drawn elements, makes redrawing MUCH faster

PGraphics offScreen;

PImage imgBackground;   // Stores background data image only.
PImage imgMain;         // Primary drawing canvas
PImage imgLocator;      // Cursor crosshairs
PImage imgButtons;      // Text buttons
PImage imgHighlight;
String BackgroundImageName = "background.png"; 
String HelpImageName = "help.png"; 

float ColorDistance;
boolean segmentQueued = false;
int queuePt1 = -1;
int queuePt2 = -1;

//float MotorStepsPerPixel =  16.75;  // For use with 1/16 steps
float MotorStepsPerPixel = 8.36;// Good for 1/8 steps-- standard behavior.
int xMotorPaperOffset =  1400;  // For 1/8 steps  Use 2900 for 1/16?

// Positions of screen items

float paintSwatchX = 108.8;
float paintSwatchY0 = 84.5;
float paintSwatchyD = 54.55;
int paintSwatchOvalWidth = 64;
int paintSwatchOvalheight = 47;

int WaterDishX = 2;
int WaterDishY0 = 88;
float WaterDishyD = 161.25;
int WaterDishDia = 118;

int MousePaperLeft =  185;
int MousePaperRight =  769;
int MousePaperTop =  62;
int MousePaperBottom =  488;

int xMotorOffsetPixels = 0;  // Corrections to initial motor position w.r.t. lower plate (paints & paper)
int yMotorOffsetPixels = 4 ;


int xBrushRestPositionPixels = 18;     // Brush rest position, in pixels
int yBrushRestPositionPixels = MousePaperTop + yMotorOffsetPixels;

int ServoUp;    // Brush UP position, native units
int ServoPaint;    // Brush DOWN position, native units. 
int ServoWash;    // Brush DOWN position, native units

int MotorMinX;
int MotorMinY;
int MotorMaxX;
int MotorMaxY;

color[] paintset = new color[9]; 

color Brown =  color(139, 69, 19);  //brown
color Purple = color(148, 0, 211);  // Purple
color Blue = color(0, 0, 255);  // BLUE
color Green = color(0, 128, 0); // GREEN
color Yellow = color(255, 255, 0);  // YELLOW
color Orange = color(255, 140, 0);  // ORANGE
color Red = color(255, 0, 0);  // RED
color Black = color(25, 25, 25);  // BLACK
color Water = color(230, 230, 255);  // BLUE 

boolean firstPath;
boolean doSerialConnect = true;
boolean SerialOnline;
Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

boolean BrushDown;
boolean BrushDownAtPause;
boolean DrawingPath = false;

int xLocAtPause;
int yLocAtPause;

int MotorX;  // Position of X motor
int MotorY;  // Position of Y motor
int MotorLocatorX;  // Position of motor locator
int MotorLocatorY; 
int lastPosition; // Record last encoded position for drawing

int selectedColor;
int selectedWater;
int highlightedWater;
int highlightedColor; 

int brushColor;

boolean recordingGesture;
boolean forceRedraw;
boolean shiftKeyDown;
boolean keyup = false;
boolean keyright = false;
boolean keyleft = false;
boolean keydown = false;
boolean hKeyDown = false;
int lastButtonUpdateX = 0;
int lastButtonUpdateY = 0;


color color_for_new_ToDo_paths = Water;
//color lastColor_DrawingPath = Water;
boolean lastBrushDown_DrawingPath;
int lastX_DrawingPath;
int lastY_DrawingPath;

int NextMoveTime;          //Time we are allowed to begin the next movement (i.e., when the current move will be complete).
int SubsequentWaitTime = -1;    //How long the following movement will take.
int UIMessageExpire;
int raiseBrushStatus;
int lowerBrushStatus;
int moveStatus;
int MoveDestX;
int MoveDestY; 
int getWaterStatus;
int WaterDest;
boolean WaterDestMode;
int PaintDest; 

int CleaningStatus;
int getPaintStatus; 
boolean Paused;

int ToDoList[];  // Queue future events in an integer array; executed when PriorityList is empty.
int indexDone;    // Index in to-do list of last action performed
int indexDrawn;   // Index in to-do list of last to-do element drawn to screen
// Active buttons
PFont font_ML16;
PFont font_CB; // Command button font
PFont font_url;
int TextColor = 75;
int LabelColor = 150;
color TextHighLight = Black;
int DefocusColor = 175;


PVector mouseSmooth = new PVector();
PVector mouseVel = new PVector();

void setup() {
  size(1200, 400);
  lineCoords = new int[height/10];
  for (int i=0; i<lineCoords.length; i++) {
    lineCoords[i] = 0;
  }
  //fullScreen();
  // ----- repeat (one line)


  Ani.init(this); // Initialize animation library
  Ani.setDefaultEasing(Ani.LINEAR);


  firstPath = true;
  shiftKeyDown = false;

  offScreen = createGraphics(2400, 400);
  frameRate(60);  // sets maximum speed only
  MotorMinX = 0;
  MotorMinY = 0;
  MotorMaxX = int(floor(xMotorPaperOffset + float(MousePaperRight - MousePaperLeft) * MotorStepsPerPixel)) ;
  MotorMaxX = 1000000;
  println("MX  "+MotorMaxX);
  println("MY  "+MotorMaxY);
  MotorMaxY = int(floor(float(MousePaperBottom - MousePaperTop) * MotorStepsPerPixel)) ;
  MotorMaxY = 1000000 ;

  println(MotorMaxX+" "+MotorMaxY);


  lastPosition = -1;
  ServoUp = 7500 + 175 * ServoUpPct;    // Brush UP position, native units
  ServoPaint = 7500 + 175 * ServoPaintPct;   // Brush DOWN position, native units. 
  ServoWash = 7500 + 175 * ServoWashPct;     // Brush DOWN position, native units
  MotorX = 0;
  MotorY = 0; 

  ToDoList = new int[0];
  ToDoList = append(ToDoList, -35);  // Command code: Go home (0,0)

  indexDone = -1;    // Index in to-do list of last action performed
  indexDrawn = -1;   // Index in to-do list of last to-do element drawn to screen
  raiseBrushStatus = -1;
  lowerBrushStatus = -1; 
  moveStatus = -1;
  MoveDestX = -1;
  MoveDestY = -1;
  Paused = false;
  BrushDownAtPause = false;

  // Set initial position of indicator at carriage minimum 0,0
  int[] pos = getMotorPixelPos();
  MotorLocatorX = pos[0];
  MotorLocatorY = pos[1];

  NextMoveTime = millis();
}

PVector snap = new PVector();

void calculSmooth()  {
  PVector diffMouse = new PVector(mouseX, mouseY).sub(mouseSmooth).mult(0.01);
  mouseVel.add(diffMouse);
  //
  if (mouseVel.mag() > 2) {
    mouseVel.normalize();
    mouseVel.mult(2);
  }
  mouseVel.mult(0.9);
  mouseSmooth.add(mouseVel);
  //
  snap.x = mouseSmooth.x;
  snap.y = mouseSmooth.y;
}

void draw() {
  //
  background(0);
  fill(255);
  rect(0, 0, width/3, height);
  fill(0);
  text(mode, 10, 10);
  noFill();
  //
  calculSmooth();
  betweenClick();
  //
  drawMoves();
  drawLines();
  //drawToDoList();

  if (doSerialConnect)
  {
    // FIRST RUN ONLY:  Connect here, so that 

    doSerialConnect = false;

    scanSerial();

    if (SerialOnline)
    {    
      myPort.write("EM,2\r");  //Configure both steppers to 1/8 step mode

      // Configure brush lift servo endpoints and speed
      myPort.write("SC,4," + str(ServoPaint) + "\r");  // Brush DOWN position, for painting
      myPort.write("SC,5," + str(ServoUp) + "\r");  // Brush UP position 

      //    myPort.write("SC,10,255\r"); // Set brush raising and lowering speed.
      myPort.write("SC,10,65535\r"); // Set brush raising and lowering speed. 65535


      // Ensure that we actually raise the brush:
      BrushDown = true;  
      raiseBrush();
    } else
    {
      // nothing
    }
  }
  image(offScreen, width/3, 0, 1200, 200);
  stroke(0, 255, 255);
  line(width/3+600, 0, width/3+600, height);
  line(width/3, 0, width/3, height);
  noStroke();
}



/*void MoveCustom(int _x, int _y) {
 int fx = floor(map(_x, 0, width, 0, 3000));
 int fy = floor(map(_y, 0, height, 0, 400));
 //println(fx, fy);
 MoveToXY(fy, fx);
 
 }*/

void keyReleased()
{

  if (key == CODED) {

    if (keyCode == UP) keyup = false; 
    if (keyCode == DOWN) keydown = false; 
    if (keyCode == LEFT) keyleft = false; 
    if (keyCode == RIGHT) keyright = false; 

    if (keyCode == SHIFT) { 

      shiftKeyDown = false;
    }
  }

  if ( key == 'h')  // display help
  {  
    /*for(int i=0; i<width; i+=10) {
     moves.add(new Move(i, 0, false));
     }*/
  }
}
int decalage = 0;
void keyPressed()
{

  int nx = 0;
  int ny = 0;

  if (key == CODED) {
    if (keyCode == UP) {
      if (repeating<24) {
        repeating++;
        
      moves = new ArrayList<Movement>();
      repeatPath(decalage);
      }
    }
    if (keyCode == DOWN) {
      if (repeating>0) {
        repeating--;
      moves = new ArrayList<Movement>();
      repeatPath(decalage);
      }
    }
    if (keyCode == RIGHT) {
      decalage+=1;
      moves = new ArrayList<Movement>();
      repeatPath(decalage);
    }
    if (keyCode == LEFT) {
      decalage-=1;
      moves = new ArrayList<Movement>();
      repeatPath(decalage);
    }
    //
  } else {
    if ( key == 'b')   // Toggle brush up or brush down with 'b' key
    {
      if (BrushDown)
        raiseBrush();
      else
        lowerBrush();
    }

    if ( key == 'q')  // Move home (0,0)
    {
      raiseBrush();
      MoveToXY(0, 0);
    }

    /*if ( key == 'v') {
     println("vv");
     myPort.write("SE,1,1023\r");
     }
     if ( key == 'w') {
     println("ww");
     myPort.write("SE,0\r");
     }*/
    if ( key == ' ')  // display help
    {
      gogogo = !gogogo;
    }


    if ( key == 't')  // Disable motors, to manually move carriage.  
      MotorsOff();

    if ( key == '1')
      MotorSpeed = 100;  
    if ( key == '2')
      MotorSpeed = 250;        
    if ( key == '3')
      MotorSpeed = 500;        
    if ( key == '4')
      MotorSpeed = 750;        
    if ( key == '5')
      MotorSpeed = 1000;        
    if ( key == '6')
      MotorSpeed = 1250;        
    if ( key == '7')
      MotorSpeed = 1500;        
    if ( key == '8')
      MotorSpeed = 1750;        
    if ( key == '9')
      MotorSpeed = 2000;
  }
}