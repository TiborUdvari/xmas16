// M_3_4_01_TOOL.pde
// GUI.pde, Mesh.pde, TileSaver.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

void setupGUI() {
  color activeColor = color(0, 130, 164);
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorCaptionLabel(color(50));
  controlP5.setColorValueLabel(color(255));


  sliders = new Slider[30];
  ranges = new Range[30];
  toggles = new Toggle[30];

  int left = 0;
  int top = 5;
  int len = 200;

  int si = 0;
  int ri = 0;
  int ti = 0;
  int posY = 0;

  //sliders[si++] = controlP5.addSlider("form",1,20,left,top+posY,len,15);
  sliders[si++] = controlP5.addSlider("repetition", 1, 20, left, top+posY+20, len, 15);
  posY += 50;
  sliders[si++] = controlP5.addSlider("repetition2", 1, 50, left, top+posY, len, 15);
  posY += 20;
  sliders[si++] = controlP5.addSlider("Hexagon Size", 1, 32, left, top+posY, len, 15);

  ranges[ri++] = controlP5.addRange("vRange", -20, 20, -PI, PI, left, top+posY+20, len, 15);
  posY += 50;

  sliders[si++] = controlP5.addSlider("paramExtra", -10, 10, left, top+posY, len, 15);
  sliders[si++] = controlP5.addSlider("meshDistortion", 0, 2, left, top+posY+20, len, 15);
  posY += 50;

  toggles[ti] = controlP5.addToggle("drawTriangles", drawTriangles, left+110, top+posY, 15, 15);
  toggles[ti++].setLabel("Draw Triangles");

  for (int i = 0; i < si; i++) {

    sliders[i].getCaptionLabel().toUpperCase(true);
    sliders[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    sliders[i].getCaptionLabel().getStyle().marginTop = -4;
    sliders[i].getCaptionLabel().getStyle().marginLeft = 0;
    sliders[i].getCaptionLabel().getStyle().marginRight = -14;
    sliders[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }
  for (int i = 0; i < ri; i++) {

    ranges[i].getCaptionLabel().toUpperCase(true);
    ranges[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    ranges[i].getCaptionLabel().getStyle().marginTop = -4;
    ranges[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }
  for (int i = 0; i < ti; i++) {

    toggles[i].setColorCaptionLabel(color(50));
    toggles[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    toggles[i].getCaptionLabel().getStyle().marginTop = -20;
    toggles[i].getCaptionLabel().getStyle().marginLeft = 18;
    toggles[i].getCaptionLabel().getStyle().marginRight = 5;
    toggles[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }
}



void drawGUI() {
  controlP5.show();
  //controlP5.hide();  
  controlP5.draw();
}


void updateColors(int stat) {
  // ControllerGroup ctrl = controlP5.getGroup("menu");

  for (int i = 0; i < sliders.length; i++) {
    if (sliders[i] == null) break;
    if (stat == 0) {
      sliders[i].setColorCaptionLabel(color(50));
      sliders[i].getCaptionLabel().setColorBackground(0x99ffffff);
    } else {
      sliders[i].setColorCaptionLabel(color(200));
      sliders[i].getCaptionLabel().setColorBackground(0x99000000);
    }
  }
  for (int i = 0; i < ranges.length; i++) {
    if (ranges[i] == null) break;
    if (stat == 0) {
      ranges[i].setColorCaptionLabel(color(50));
      ranges[i].getCaptionLabel().setColorBackground(0x99ffffff);
    } else {
      ranges[i].setColorCaptionLabel(color(200));
      ranges[i].getCaptionLabel().setColorBackground(0x99000000);
    }
  }
  for (int i = 0; i < toggles.length; i++) {
    if (toggles[i] == null) break;
    if (stat == 0) {
      toggles[i].setColorCaptionLabel(color(50));
      toggles[i].getCaptionLabel().setColorBackground(0x99ffffff);
    } else {
      toggles[i].setColorCaptionLabel(color(200));
      toggles[i].getCaptionLabel().setColorBackground(0x99000000);
    }
  }
}

void drawTriangles() {
  if (frameCount > guiEventFrame+1) {
    guiEventFrame = frameCount;
    drawTriangles = !drawTriangles;
  }
}



void controlEvent(ControlEvent theControlEvent) {
  guiEventFrame = frameCount;

  if (theControlEvent.isController()) {
    if (theControlEvent.getController().getName().equals("repetition")) {
      float f = theControlEvent.getController().getValue();
      repeat = f;
    }
    if (theControlEvent.getController().getName().equals("repetition2")) {
      float f = theControlEvent.getController().getValue();
      HexSpacing = f;
    }
    if (theControlEvent.getController().getName().equals("Hexagon Size")) {
      float f = theControlEvent.getController().getValue();
      HexSize = f;
    }
  }
}