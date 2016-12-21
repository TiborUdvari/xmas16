void roulette()  {
  translate(4000, 0);
  rotate(angleCurrent);
  for (int i=1; i<=100; i++)  {
    pushMatrix();
    rotate(i*angle);
    translate(-4000, 0);
    text(i, 0, 70);
    image(barbanime[i%barbanime.length], 500, 0, 200, 200);
    popMatrix();
  }
}