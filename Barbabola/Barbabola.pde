int r ;
float angle = TAU/100;
float angleFinal = 0;
float angleCurrent = 0;
float angleDuring = PI/50+0.001;
PImage[] barbanime = new PImage[9];
boolean roll = false;
//
void setup() {
  fullScreen();
  r = floor(random(100))+1;
  for (int i=0; i<9; i++)  {
    barbanime[i] = loadImage("barba_"+i+".png");
  }
  println(r);
  imageMode(CENTER);
  textMode(CENTER);
  textAlign(CENTER);
  rectMode(CENTER);
  textSize(200);
  angleFinal = 10*TAU-r*angle;
}
void draw() {
  background(255);
  fill(0);
  noStroke();
  if (!roll) {
    angleCurrent += angleDuring;
  } else {
    angleCurrent += (angleFinal-angleCurrent)/50.0;
  }
  translate(width/3, height/2);
  //scale(0.1, 0.1);
  noFill();
  strokeWeight(5);
  stroke(0);
  //rect(0, 0, 300, 300);
  line(-200, 100, 200, 100);
  roulette();
}
void keyPressed () {
  if (key == ' ' && roll == false)  {
    roll = true;
    angleFinal = (angleCurrent-(angleCurrent%TAU))+TAU*2-r*angle;
    //if(angleCurrent%TAU-r*angle <) {
    //}
  }
}