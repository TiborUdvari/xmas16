void drawRect(int x, int y) {
  pushMatrix();
  translate(x*stepX, y*stepY);
  translate(stepX/2, stepY/2);
  //ellipse(0, 0, 4, 4);
  if(rot[y][x]) {
   rotate(PI/2);
  }
  //translate(-stepX/2, -stepY/2);
  line(-stepX/2, -stepY/2, stepX/2, stepY/2);
  popMatrix();
}
void drawRectV(int x, int y) {
  pushMatrix();
  translate(x*stepX, y*stepY);
  translate(stepX/2, stepY/2);
  //ellipse(0, 0, 4, 4);
  if(rot[y][x]) {
   rotate(PI/2);
  }
  //translate(-stepX/2, -stepY/2);
  line(-stepX/2, -stepY/2, -stepX/2, stepY/2);
  line(stepX/2, -stepY/2, stepX/2, stepY/2);
  popMatrix();
}