int r ;
float angle = TAU/100;
float angleFinal = 0;
float angleCurrent = 0;
float angleDuring = PI/50+0.001;
PImage[] barbanime = new PImage[9];
PImage[] barbappy = new PImage[7];
boolean roll = false;
int[] remove = {51,29,40,62,10,21,50,51,52,53,54,55,49,56,48,47,57,58,59,60,61,62,63,64,65,67,45,84,85,86,82,81,83,87,88,89,90,75,91,92,93,94,95,96,97,74,98,79,99,78,80,76,77,100} ;
//
void setup() {
  fullScreen();
  boolean needRandom = true;
  while(needRandom) {
    r = floor(random(100))+1;
    r = 53;
    for(int i=0; i<remove.length; i++) {
      if(r == remove[i]) {
        r = floor(random(100))+1;
        println(r+" not bought !");
        //break;
      } else {
        needRandom = false;
        break;
      }
    }
  }
  //
  //
  for (int i=0; i<barbanime.length; i++)  {
    barbanime[i] = loadImage("barba_"+i+".png");
  }
  for (int i=0; i<barbappy.length; i++)  {
    barbappy[i] = loadImage("barbabis_"+i+".png");
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
  if(abs(angleCurrent-angleFinal)<1) {
    image(barbappy[frameCount%barbappy.length], 550, 0);
  }
}
void keyPressed () {
  if (key == ' ' && roll == false)  {
    roll = true;
    angleFinal = (angleCurrent-(angleCurrent%TAU))+TAU*3-r*angle;
    //if(angleCurrent%TAU-r*angle <) {
    //}
  }
}