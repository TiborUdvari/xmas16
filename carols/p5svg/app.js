var monoFont;
var w = 800;
var aspectRatio = 14.8 / 10.3;
var rm = new RiMarkov(4);
var prose = "MAKE XMAS GREAT AGAIN";
var tSize = 50;
var debug = false;

function preload() {
    monoFont = loadFont("MonoMono_17.otf");
    rm.loadFrom("mid+xmas.txt");
}

function setup() {
	console.log("setup");
	createCanvas(w, w * aspectRatio, SVG);
	background(255);
	noFill();
	strokeWeight(1);
}

function draw() {
	background(255);

	if (mouseIsPressed) {
		tSize = map(mouseX, 0, width, 10, 200);
	}

	textSize(tSize);

	if (debug){
		background(100); 

		rect(width * 0.1, height * 0.3, width * 0.8, height * 0.6);
		fill(0, 0, 0);
	}

	stroke(0);
	textFont(monoFont);
  text(prose.toUpperCase(), width * 0.1, height * 0.3, width * 0.8, height * 0.6);

  if (debug) {
  	fill(0, 102, 153);
  }
}

function keyPressed() {
  if (keyCode === RETURN) {
    save();
  } else if (keyCode === ESCAPE){
  	var sentences = rm.generateSentences(2);
		console.log(sentences);
		var allText = sentences.reduce(function(t, i){ return t + " " + i });
		prose = allText;
  }
}
