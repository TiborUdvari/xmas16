int r ;
float angle = TAU/100;
float angleFinal = 0;
float angleCurrent = 0;
PImage[] barbanime = new PImage[9];
//
void setup() {
  fullScreen();
  r = floor(random(100))+1;
  for(int i=0; i<9; i++) {
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
  angleCurrent += (angleFinal-angleCurrent)/49.0;
  translate(width/3, height/2);
  noFill();
  strokeWeight(5);
  stroke(0);
  //rect(0, 0, 300, 300);
  line(-200, 100, 200, 100);
  roulette();
  
}